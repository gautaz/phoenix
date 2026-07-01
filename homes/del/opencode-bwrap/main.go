package main

import (
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"
	"time"
)

var (
	logger *slog.Logger

	bwrapPath       = "bwrap"
	betterleaksPath = "betterleaks"
	passPath        = "pass"
	opencodePath    = "opencode"
)

func main() {
	debugCmdStr := os.Getenv("OPENCODE_DEBUG_CMD")
	var innerCmd []string
	if debugCmdStr != "" {
		innerCmd = strings.Fields(debugCmdStr)
	} else {
		innerCmd = []string{opencodePath}
	}
	innerCmd = append(innerCmd, os.Args[1:]...)

	xdg := xdgRuntimeDir()
	pwd, _ := os.Getwd()

	rundirBase := filepath.Join(xdg, "opencode-bwrap")
	if err := os.MkdirAll(rundirBase, 0o700); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create rundir base: %v\n", err)
		os.Exit(1)
	}
	myPID := os.Getpid()

	rundir := filepath.Join(rundirBase, strconv.Itoa(myPID))
	if err := os.MkdirAll(rundir, 0o700); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create rundir: %v\n", err)
		os.Exit(1)
	}

	logArchiveDir := filepath.Join(xdgStateHome(), "opencode-bwrap", "logs")
	if err := os.MkdirAll(logArchiveDir, 0o700); err != nil {
		fmt.Fprintf(os.Stderr, "WARNING! Failed to create log dir: %v\n", err)
	}
	logPath := filepath.Join(logArchiveDir, fmt.Sprintf("%s_%d.log", time.Now().Format("2006-01-02T15-04-05"), myPID))
	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o600)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create log file: %v\n", err)
		os.Exit(1)
	}
	logger = slog.New(slog.NewTextHandler(logFile, nil))

	cleanupStaleDirs(rundirBase, myPID)

	secretFiles, err := runBetterleaks(pwd)
	if err != nil {
		errMsg := fmt.Sprintf("betterleaks failed: %v", err)
		logger.Error(errMsg)
		fmt.Fprintf(os.Stderr, "%s\nSee %s for details.\n", errMsg, logPath)
		os.Exit(1)
	}
	logger.Info("secret files masked", "count", len(secretFiles), "paths", secretFiles)

	proxyStop := func() {}
	defer func() {
		proxyStop()
		if logFile != nil {
			if err := logFile.Sync(); err != nil {
				fmt.Fprintf(os.Stderr, "WARNING! Failed to sync log file: %v\n", err)
			}
			if err := logFile.Close(); err != nil {
				fmt.Fprintf(os.Stderr, "WARNING! Failed to close log file: %v\n", err)
			}
		}
		if err := os.RemoveAll(rundir); err != nil {
			fmt.Fprintf(os.Stderr, "WARNING! Failed to remove rundir %s: %v\n", rundir, err)
		}
	}()

	archiveAndExit := func(code int) {
		if logFile != nil {
			if err := logFile.Sync(); err != nil {
				fmt.Fprintf(os.Stderr, "WARNING! Failed to sync log file: %v\n", err)
			}
			if err := logFile.Close(); err != nil {
				fmt.Fprintf(os.Stderr, "WARNING! Failed to close log file: %v\n", err)
			}
		}
		os.Exit(code)
	}

	podmanSocket := podmanSocketPath()
	proxyBind := ""

	if _, err := os.Stat(podmanSocket); err == nil {
		secretsFile := filepath.Join(rundir, "secrets")
		secretsContent := strings.Join(secretFiles, "\n") + "\n"
		if err := os.WriteFile(secretsFile, []byte(secretsContent), 0o600); err != nil {
			logger.Error("failed to write secrets", "err", err)
			fmt.Fprintf(os.Stderr, "Failed to write secrets: %v\n", err)
			archiveAndExit(1)
		}

		proxySocket := filepath.Join(rundir, "proxy.sock")
		secrets := readSecrets(secretsFile)
		logger.Info("starting podman proxy")
		stop, err := startProxy(proxySocket, podmanSocket, secrets)
		if err != nil {
			logger.Error("failed to start proxy", "err", err)
			fmt.Fprintf(os.Stderr, "Failed to start proxy: %v\n", err)
			archiveAndExit(1)
		}
		proxyStop = stop
		logger.Info("podman proxy started", "socket", proxySocket)

		for i := 0; i < 20; i++ {
			if _, err := os.Stat(proxySocket); err == nil {
				break
			}
			time.Sleep(100 * time.Millisecond)
		}

		proxyBind = proxySocket + ":/tmp/podman-proxy.sock"
	}

	nvidiaKey := getPass("moovency/www/build.nvidia.com/api-key/opencode")
	ollamaKey := getPass("www/ollama.com/api-key/opencode")

	bwrapArgs := buildBwrapArgs(bwrapConfig{
		secretFiles:   secretFiles,
		proxyBind:     proxyBind,
		xdgRuntime:    "/tmp",
		containerHost: "unix:///tmp/podman-proxy.sock",
		nvidiaKey:     nvidiaKey,
		ollamaKey:     ollamaKey,
	})

	bwrapArgs = append(bwrapArgs, innerCmd...)

	cmd := exec.Command(bwrapPath, bwrapArgs...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGTERM, syscall.SIGINT)

	logger.Info("starting bwrap")
	if err := cmd.Start(); err != nil {
		logger.Error("failed to start bwrap", "err", err)
		fmt.Fprintf(os.Stderr, "Failed to start bwrap: %v\n", err)
		archiveAndExit(1)
	}
	logger.Info("bwrap started", "pid", cmd.Process.Pid)

	done := make(chan error, 1)
	go func() {
		done <- cmd.Wait()
	}()

	var bwrapErr error
	select {
	case sig := <-sigCh:
		if err := cmd.Process.Signal(sig); err != nil {
			logger.Warn("failed to forward signal to bwrap", "err", err)
		}
		bwrapErr = <-done
	case bwrapErr = <-done:
	}

	if bwrapErr != nil {
		if exitErr, ok := bwrapErr.(*exec.ExitError); ok {
			if status, ok := exitErr.Sys().(syscall.WaitStatus); ok {
				archiveAndExit(status.ExitStatus())
			}
		}
		archiveAndExit(1)
	}
	logger.Info("bwrap exited")
}
