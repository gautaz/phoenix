package main

import (
	"os"
	"path/filepath"
	"strings"
)

type bwrapConfig struct {
	secretFiles   []string
	proxyBind     string
	xdgRuntime    string
	containerHost string
	nvidiaKey     string
	ollamaKey     string
}

func buildBwrapArgs(cfg bwrapConfig) []string {
	home := homeDir()
	pwd, _ := os.Getwd()
	userName := filepath.Base(home)

	var args []string

	args = append(args,
		"--proc", "/proc",
		"--dev", "/dev",
		"--tmpfs", "/tmp",
		"--chdir", pwd,
	)

	roPaths := []string{
		"/etc/hosts",
		"/etc/nsswitch.conf",
		"/etc/resolv.conf",
		"/nix/store",
		"/run/current-system/sw",
		"/run/wrappers",
		"/usr/bin",
		"/bin",
		filepath.Join("/etc/profiles/per-user", userName),
		filepath.Join(home, ".local/bin"),
		filepath.Join(home, ".nix-profile"),
	}

	for _, p := range roPaths {
		if exists(p) {
			args = append(args, "--ro-bind", p, p)
		} else {
			logger.Warn("skipping missing ro-bind path", "path", p)
		}
	}

	bindPaths := []string{
		filepath.Join(home, ".config/opencode"),
		filepath.Join(home, ".local/share/opencode"),
		filepath.Join(home, ".local/state/opencode"),
		pwd,
	}

	for _, p := range bindPaths {
		if exists(p) {
			args = append(args, "--bind", p, p)
		} else {
			logger.Warn("skipping missing bind path", "path", p)
		}
	}

	cacheSource := filepath.Join(home, ".cache/opencode-bwrap")
	cacheTarget := filepath.Join(home, ".cache")
	if err := os.MkdirAll(cacheSource, 0o700); err != nil {
		logger.Warn("failed to create cache bind source", "path", cacheSource, "err", err)
	} else {
		args = append(args, "--bind", cacheSource, cacheTarget)
	}

	for _, secret := range cfg.secretFiles {
		args = append(args, "--bind", "/dev/null", secret)
	}

	if cfg.proxyBind != "" {
		parts := strings.SplitN(cfg.proxyBind, ":", 2)
		if len(parts) == 2 {
			args = append(args, "--bind", parts[0], parts[1])
		}
	}

	args = append(args,
		"--setenv", "NVIDIA_API_KEY", cfg.nvidiaKey,
		"--setenv", "OLLAMA_API_KEY", cfg.ollamaKey,
		"--setenv", "XDG_RUNTIME_DIR", cfg.xdgRuntime,
		"--setenv", "CONTAINER_HOST", cfg.containerHost,
	)

	return args
}
