package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type mount struct {
	Type   string `json:"Type"`
	Source string `json:"Source"`
	Target string `json:"Target"`
}

type hostConfig struct {
	Binds  []string `json:"Binds"`
	Mounts []mount  `json:"Mounts"`
}

type createConfig struct {
	HostConfig *hostConfig `json:"HostConfig"`
}

func main() {
	listenPath := flag.String("listen", "", "proxy Unix socket path")
	realPath := flag.String("real", "", "real podman Unix socket path")
	secretsPath := flag.String("secrets", "", "file with secret paths, one per line")
	flag.Parse()

	if *listenPath == "" || *realPath == "" || *secretsPath == "" {
		fmt.Fprintf(os.Stderr, "Usage: opencode-bwrap-podman-proxy --listen <socket> --real <socket> --secrets <file>\n")
		os.Exit(1)
	}

	secrets := readSecrets(*secretsPath)

	dir := filepath.Dir(*listenPath)
	if err := os.MkdirAll(dir, 0700); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create directory %s: %v\n", dir, err)
		os.Exit(1)
	}

	listener, err := net.Listen("unix", *listenPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to listen on %s: %v\n", *listenPath, err)
		os.Exit(1)
	}
	defer listener.Close()

	if err := os.Chmod(*listenPath, 0700); err != nil {
		fmt.Fprintf(os.Stderr, "Failed to chmod socket: %v\n", err)
		os.Exit(1)
	}

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Accept error: %v\n", err)
			continue
		}
		go handle(conn, *realPath, secrets)
	}
}

func readSecrets(path string) []string {
	data, err := os.ReadFile(path)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to read secrets file: %v\n", err)
		os.Exit(1)
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

func containsSecret(mountSource string, secrets []string) bool {
	clean := filepath.Clean(mountSource)
	for _, s := range secrets {
		cs := filepath.Clean(s)
		if cs == clean ||
			strings.HasPrefix(cs, clean+"/") ||
			strings.HasPrefix(clean, cs+"/") {
			return true
		}
	}
	return false
}

func checkBinds(binds []string, secrets []string) string {
	for _, b := range binds {
		source := strings.SplitN(b, ":", 2)[0]
		if containsSecret(source, secrets) {
			return source
		}
	}
	return ""
}

func checkMounts(mounts []mount, secrets []string) string {
	for _, m := range mounts {
		if m.Type == "bind" && m.Source != "" && containsSecret(m.Source, secrets) {
			return m.Source
		}
	}
	return ""
}

func detectAPIVersion(path string) string {
	parts := strings.Split(strings.TrimPrefix(path, "/"), "/")
	if len(parts) > 0 && len(parts[0]) > 1 && parts[0][0] == 'v' {
		c := parts[0][1]
		if c >= '0' && c <= '9' {
			return parts[0]
		}
	}
	return ""
}

func isCreateOp(method, path string) bool {
	if method != "POST" {
		return false
	}
	base := strings.TrimPrefix(path, "/")
	ver := detectAPIVersion(path)
	if ver != "" {
		base = strings.TrimPrefix(strings.TrimPrefix(path, "/"+ver), "/")
	}
	return base == "containers/create" || strings.HasSuffix(base, "/containers/create")
}

func handle(clientConn net.Conn, realPath string, secrets []string) {
	defer clientConn.Close()

	req, err := http.ReadRequest(bufio.NewReader(clientConn))
	if err != nil {
		return
	}

	body, err := io.ReadAll(req.Body)
	req.Body.Close()
	if err != nil {
		return
	}

	if isCreateOp(req.Method, req.URL.Path) {
		var cfg createConfig
		if err := json.Unmarshal(body, &cfg); err == nil && cfg.HostConfig != nil {
			if source := checkBinds(cfg.HostConfig.Binds, secrets); source != "" {
				writeForbidden(clientConn, fmt.Sprintf("Mount source contains secret paths: %s", source))
				return
			}
			if source := checkMounts(cfg.HostConfig.Mounts, secrets); source != "" {
				writeForbidden(clientConn, fmt.Sprintf("Mount source contains secret paths: %s", source))
				return
			}
		}
	}

	realConn, err := net.Dial("unix", realPath)
	if err != nil {
		writeError(clientConn, fmt.Sprintf("Cannot connect to podman: %v", err))
		return
	}
	defer realConn.Close()

	req.Body = io.NopCloser(bytes.NewReader(body))
	req.ContentLength = int64(len(body))
	req.RequestURI = ""
	if err := req.Write(realConn); err != nil {
		return
	}

	resp, err := http.ReadResponse(bufio.NewReader(realConn), req)
	if err != nil {
		return
	}
	defer resp.Body.Close()

	resp.Write(clientConn)
}

func writeForbidden(conn net.Conn, msg string) {
	body := fmt.Sprintf(`{"message":"%s"}`, msg)
	resp := &http.Response{
		StatusCode: http.StatusForbidden,
		ProtoMajor: 1,
		ProtoMinor: 1,
		Header: http.Header{
			"Content-Type":   []string{"application/json"},
			"Content-Length": []string{fmt.Sprintf("%d", len(body))},
		},
		Body:          io.NopCloser(strings.NewReader(body)),
		ContentLength: int64(len(body)),
	}
	resp.Write(conn)
}

func writeError(conn net.Conn, msg string) {
	body := fmt.Sprintf(`{"message":"%s"}`, msg)
	resp := &http.Response{
		StatusCode: http.StatusBadGateway,
		ProtoMajor: 1,
		ProtoMinor: 1,
		Header: http.Header{
			"Content-Type":   []string{"application/json"},
			"Content-Length": []string{fmt.Sprintf("%d", len(body))},
		},
		Body:          io.NopCloser(strings.NewReader(body)),
		ContentLength: int64(len(body)),
	}
	resp.Write(conn)
}
