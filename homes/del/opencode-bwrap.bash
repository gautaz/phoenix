SECRET_FILES=()
while IFS= read -r file; do
  SECRET_FILES+=("$file")
done < <(
  betterleaks dir \
      --no-banner \
      --no-color \
      --max-target-megabytes 1 \
      --redact \
      -l fatal \
      -f template \
      --report-template <(printf '%s\n' '{{ range . }}{{ .File }}{{ "\n" }}{{ end }}') \
      -r - \
      "$PWD" |
    awk 'NF' |
    sort -u
)

RO_BIND_PATHS=(
  /etc/hosts
  /etc/nsswitch.conf
  /etc/resolv.conf
  /nix/store
  /run/current-system/sw
  /run/wrappers
  /usr/bin
  /bin
  /etc/profiles/per-user/"$(basename "$HOME")"
  "$HOME/.local/bin"
  "$HOME/.nix-profile"
)

BIND_PATHS=(
  "$HOME/.config/opencode"
  "$HOME/.local/share/opencode"
  "$HOME/.local/state/opencode"
  "$PWD"
)

declare -A BIND_MAP_PATHS=(
  ["$HOME/.cache"]="$HOME/.cache/opencode-bwrap"
)

BWRAP_ARGS=(
  --proc /proc
  --dev /dev
  --tmpfs /tmp
  --chdir "$PWD"
)

for path in "${RO_BIND_PATHS[@]}"; do
  if [[ ! -e $path ]]; then
    echo "WARNING! Skipping missing ro-bind path: $path" >&2
    continue
  fi
  BWRAP_ARGS+=(--ro-bind "$path" "$path")
done

for path in "${BIND_PATHS[@]}"; do
  if [[ ! -e $path ]]; then
    echo "WARNING! Skipping missing bind path: $path" >&2
    continue
  fi
  BWRAP_ARGS+=(--bind "$path" "$path")
done

for target in "${!BIND_MAP_PATHS[@]}"; do
  source="${BIND_MAP_PATHS[$target]}"
  if ! mkdir -p "$source"; then
    echo "WARNING! Skipping missing bind-map path: $source" >&2
    continue
  fi
  BWRAP_ARGS+=(--bind "$source" "$target")
done

for secret in "${SECRET_FILES[@]}"; do
  BWRAP_ARGS+=(--bind /dev/null "$secret")
done

shopt -s nullglob
for d in "$XDG_RUNTIME_DIR"/opencode-bwrap/*/; do
  pid=$(basename "$d")
  [[ $pid == "$$" ]] && continue
  [[ -d /proc/$pid ]] || rm -rf "$d"
done
shopt -u nullglob

PROXY_PID=
PROXY_SOCKET_TARGET=/tmp/podman-proxy.sock
if [[ -S $XDG_RUNTIME_DIR/podman/podman.sock ]]; then
  RUNDIR="$XDG_RUNTIME_DIR/opencode-bwrap/$$"
  mkdir -p "$RUNDIR"

  SECRETS_FILE="$RUNDIR/secrets"
  PROXY_SOCKET="$RUNDIR/proxy.sock"

  printf '%s\n' "${SECRET_FILES[@]}" > "$SECRETS_FILE"

  opencode-bwrap-podman-proxy \
    --listen "$PROXY_SOCKET" \
    --real "$XDG_RUNTIME_DIR/podman/podman.sock" \
    --secrets "$SECRETS_FILE" &
  PROXY_PID=$!

  for _ in $(seq 1 20); do
    [[ -S $PROXY_SOCKET ]] && break
    sleep 0.1
  done

  BWRAP_ARGS+=(--bind "$PROXY_SOCKET" "$PROXY_SOCKET_TARGET")
fi

cleanup() {
  [[ -n $PROXY_PID ]] && kill "$PROXY_PID" 2>/dev/null
  [[ -n $RUNDIR && -d $RUNDIR ]] && rm -rf "$RUNDIR"
}
trap cleanup EXIT TERM INT

IFS=' ' read -ra DEBUG_CMD <<< "${OPENCODE_DEBUG_CMD:-opencode}"
CMD=("${DEBUG_CMD[@]}" "$@")

bwrap \
  --setenv NVIDIA_API_KEY "$(pass moovency/www/build.nvidia.com/api-key/opencode)" \
  --setenv OLLAMA_API_KEY "$(pass www/ollama.com/api-key/opencode)" \
  --setenv XDG_RUNTIME_DIR /tmp \
  --setenv CONTAINER_HOST "unix://$PROXY_SOCKET_TARGET" \
  "${BWRAP_ARGS[@]}" "${CMD[@]}"
