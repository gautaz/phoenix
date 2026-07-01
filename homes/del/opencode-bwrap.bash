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
  BWRAP_ARGS+=(--ro-bind "$path" "$path")
done

for path in "${BIND_PATHS[@]}"; do
  BWRAP_ARGS+=(--bind "$path" "$path")
done

for target in "${!BIND_MAP_PATHS[@]}"; do
  source="${BIND_MAP_PATHS[$target]}"
  mkdir -p "$source"
  BWRAP_ARGS+=(--bind "$source" "$target")
done

for secret in "${SECRET_FILES[@]}"; do
  BWRAP_ARGS+=(--bind /dev/null "$secret")
done

IFS=' ' read -ra DEBUG_CMD <<< "${OPENCODE_DEBUG_CMD:-opencode}"
CMD=("${DEBUG_CMD[@]}" "$@")

exec bwrap \
  --setenv NVIDIA_API_KEY "$(pass moovency/www/build.nvidia.com/api-key/opencode)" \
  --setenv OLLAMA_API_KEY "$(pass www/ollama.com/api-key/opencode)" \
  "${BWRAP_ARGS[@]}" "${CMD[@]}"
