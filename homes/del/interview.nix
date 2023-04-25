{pkgs, ...}:
with pkgs; let
  interview = writeShellApplication {
    name = "interview";
    runtimeInputs = [
      bat
      chafa
      coreutils
      file
      poppler_utils
      tree
    ];
    text = ''
      FILETYPE="$(file --brief --mime "$1")"
      case "$FILETYPE" in
        application/pdf\;*)
          TMPDIR="$(mktemp -d)"
          pdftoppm -singlefile "$1" "$TMPDIR/preview"
          chafa "$TMPDIR/preview.ppm"
          rm -rf "$TMPDIR"
          ;;
        image/*)
          chafa "$1"
          ;;
        inode/directory\;*)
          tree -d "$1"
          ;;
        inode/symlink\;*)
          interview "$(readlink -f "$1")"
          ;;
        text/*)
          bat --color=always --style=numbers --line-range=:500 "$1"
          ;;
        *)
        echo "No preview for $FILETYPE"
          ;;
      esac
    '';
  };
in {
  home.packages = [interview];
}
