exec bwrap \
  --proc /proc --dev /dev \
  --tmpfs /tmp \
  --ro-bind /etc/hosts /etc/hosts \
  --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
  --ro-bind /etc/profiles/per-user/"$(basename "$HOME")" /etc/profiles/per-user/"$(basename "$HOME")" \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --ro-bind /nix/store /nix/store \
  --ro-bind /run/current-system/sw /run/current-system/sw \
  --ro-bind /run/wrappers /run/wrappers \
  --ro-bind "$HOME/.local/bin" "$HOME/.local/bin" \
  --ro-bind "$HOME/.nix-profile" "$HOME/.nix-profile" \
  --bind "$HOME/.config/opencode" "$HOME/.config/opencode" \
  --bind "$HOME/.local/share/opencode" "$HOME/.local/share/opencode" \
  --bind "$HOME/.local/state/opencode" "$HOME/.local/state/opencode" \
  --bind "$PWD" "$PWD" \
  --chdir "$PWD" \
  opencode "$@"
