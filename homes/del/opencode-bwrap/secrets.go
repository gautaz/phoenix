package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"sort"
	"strings"
)

func readSecrets(path string) []string {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil
	}
	var secrets []string
	for _, line := range strings.Split(string(data), "\n") {
		line = strings.TrimSpace(line)
		if line != "" {
			secrets = append(secrets, line)
		}
	}
	return secrets
}

type betterleaksFinding struct {
	File string `json:"File"`
}

func runBetterleaks(dir string) ([]string, error) {
	cmd := exec.Command(betterleaksPath, "dir",
		"--no-banner",
		"--no-color",
		"--max-target-megabytes", "1",
		"--redact",
		"-l", "error",
		"--exit-code", "0",
		"-f", "json",
		"-r", "-",
		dir)
	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr
	var runErr error
	if err := cmd.Run(); err != nil {
		runErr = fmt.Errorf("betterleaks: %w\n%s", err, stderr.String())
	}

	var findings []betterleaksFinding
	if err := json.Unmarshal(stdout.Bytes(), &findings); err != nil {
		if runErr != nil {
			return nil, runErr
		}
		return nil, fmt.Errorf("parse findings: %w", err)
	}

	seen := make(map[string]bool)
	var files []string
	for _, f := range findings {
		file := f.File
		if file != "" && !seen[file] {
			seen[file] = true
			files = append(files, file)
		}
	}
	sort.Strings(files)
	return files, nil
}
