TEMP="$(mktemp)"
# Some interesting nixfmt rules are missing from nixpkgs-fmt
nixfmt < "$1" | nixpkgs-fmt > "$TEMP"
mv "$TEMP" "$1"
