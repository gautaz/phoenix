{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  findCommand = "${fd}/bin/fd --follow --exclude \".git\"";
  fsPreviewOption = lib.strings.concatStringsSep " " fsPreviewOptionList;
  fsPreviewOptionList = ["--preview 'interview {}'"];
in {
  programs = {
    bash.initExtra = ''
      _fzf_compgen_path() {
        ${findCommand} . "$1"
      }
      export _fzf_compgen_path

      _fzf_compgen_dir() {
        ${findCommand} --type d . "$1"
      }
      export _fzf_compgen_dir

      _fzf_comprun() {
        local command="$1"
        shift
        case "$command" in
          export|unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
          ssh) fzf --preview '${dnsutils}/bin/dig {}' "$@" ;;
          *) fzf ${fsPreviewOption} "$@" ;;
        esac
      }
      export _fzf_comprun
    '';

    fzf = {
      changeDirWidgetOptions = fsPreviewOptionList;
      defaultCommand = "${findCommand}";
      fileWidgetOptions = fsPreviewOptionList;
      enable = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
