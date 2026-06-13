SECRET_FILES=()
while IFS= read -r file; do
  SECRET_FILES+=("$file")
done < <(
  gitleaks dir --no-banner --redact -f json -r - "$PWD" 2>/dev/null |
    jq -r '.[].File | select(. != null)' |
    sort -u
)

RO_BIND_PATHS=(
  /etc/hosts
  /etc/nsswitch.conf
  /etc/resolv.conf
  /nix/store
  /run/current-system/sw
  /run/wrappers
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

for secret in "${SECRET_FILES[@]}"; do
  BWRAP_ARGS+=(--bind /dev/null "$secret")
done

exec bwrap "${BWRAP_ARGS[@]}" opencode "$@"
