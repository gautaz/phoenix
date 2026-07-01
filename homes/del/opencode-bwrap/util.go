package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

func runCmd(cmd string, args ...string) (string, error) {
	var stdout, stderr bytes.Buffer
	c := exec.Command(cmd, args...)
	c.Stdout = &stdout
	c.Stderr = &stderr
	if err := c.Run(); err != nil {
		return "", fmt.Errorf("%s: %w\nstderr: %s", cmd, err, stderr.String())
	}
	return stdout.String(), nil
}

func getPass(path string) string {
	out, err := runCmd(passPath, path)
	if err != nil {
		logger.Warn("failed to get pass", "path", path, "err", err)
		return ""
	}
	return strings.TrimSpace(out)
}

func exists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

func homeDir() string {
	if h := os.Getenv("HOME"); h != "" {
		return h
	}
	return "/root"
}

func xdgRuntimeDir() string {
	if d := os.Getenv("XDG_RUNTIME_DIR"); d != "" {
		return d
	}
	return "/run/user/1000"
}

func xdgStateHome() string {
	if v := os.Getenv("XDG_STATE_HOME"); v != "" {
		return v
	}
	return filepath.Join(os.Getenv("HOME"), ".local", "state")
}

func podmanSocketPath() string {
	return filepath.Join(xdgRuntimeDir(), "podman", "podman.sock")
}

func cleanupStaleDirs(base string, myPID int) {
	entries, err := os.ReadDir(base)
	if err != nil {
		return
	}
	for _, e := range entries {
		if !e.IsDir() {
			continue
		}
		pid, err := strconv.Atoi(e.Name())
		if err != nil || pid == myPID {
			continue
		}
		procPath := filepath.Join("/proc", e.Name())
		if _, err := os.Stat(procPath); os.IsNotExist(err) {
			if err := os.RemoveAll(filepath.Join(base, e.Name())); err != nil {
				logger.Warn("failed to remove stale rundir",
					"path", filepath.Join(base, e.Name()), "err", err)
			}
		}
	}
}
