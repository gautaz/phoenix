package main

import (
	"bufio"
	"bytes"
	"encoding/json"
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

func proxyHandle(clientConn net.Conn, realPath string, secrets []string) {
	defer func() {
		if err := clientConn.Close(); err != nil {
			logger.Warn("failed to close client connection", "err", err)
		}
	}()

	req, err := http.ReadRequest(bufio.NewReader(clientConn))
	if err != nil {
		return
	}

	body, err := io.ReadAll(req.Body)
	if err := req.Body.Close(); err != nil {
		logger.Warn("failed to close request body", "err", err)
	}
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
	defer func() {
		if err := realConn.Close(); err != nil {
			logger.Warn("failed to close real connection", "err", err)
		}
	}()

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
	defer func() {
		if err := resp.Body.Close(); err != nil {
			logger.Warn("failed to close response body", "err", err)
		}
	}()
	if err := resp.Write(clientConn); err != nil {
		logger.Error("failed to write response", "err", err)
	}
}

func writeResponse(conn net.Conn, status int, msg string) {
	body := fmt.Sprintf(`{"message":"%s"}`, msg)
	resp := &http.Response{
		StatusCode: status,
		ProtoMajor: 1,
		ProtoMinor: 1,
		Header: http.Header{
			"Content-Type":   []string{"application/json"},
			"Content-Length": []string{fmt.Sprintf("%d", len(body))},
		},
		Body:          io.NopCloser(strings.NewReader(body)),
		ContentLength: int64(len(body)),
	}
	if err := resp.Write(conn); err != nil {
		logger.Error("failed to write error response", "status", status, "err", err)
	}
}

func writeForbidden(conn net.Conn, msg string) {
	writeResponse(conn, http.StatusForbidden, msg)
}

func writeError(conn net.Conn, msg string) {
	writeResponse(conn, http.StatusBadGateway, msg)
}

func startProxy(listenPath, realPath string, secrets []string) (func(), error) {
	dir := filepath.Dir(listenPath)
	if err := os.MkdirAll(dir, 0o700); err != nil {
		return nil, fmt.Errorf("create proxy dir: %w", err)
	}

	listener, err := net.Listen("unix", listenPath)
	if err != nil {
		return nil, fmt.Errorf("listen on %s: %w", listenPath, err)
	}

	if err := os.Chmod(listenPath, 0o700); err != nil {
		if err := listener.Close(); err != nil {
			logger.Warn("failed to close listener after chmod error", "err", err)
		}
		return nil, fmt.Errorf("chmod socket: %w", err)
	}

	go func() {
		for {
			conn, err := listener.Accept()
			if err != nil {
				return
			}
			go proxyHandle(conn, realPath, secrets)
		}
	}()

	return func() {
		if err := listener.Close(); err != nil {
			logger.Warn("failed to close listener", "err", err)
		}
	}, nil
}
