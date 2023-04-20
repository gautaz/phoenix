{pkgs, ...}:
with pkgs; let
  fzfCommand = "${fd}/bin/fd --follow --exclude \".git\"";
in {
  home.packages = [
    fd
  ];

  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
      defaultCommand = "${fzfCommand}";
    };

    bash.initExtra = ''
      _fzf_compgen_path() {
        ${fzfCommand} . "$1"
      }
      export _fzf_compgen_path

      _fzf_compgen_dir() {
        ${fzfCommand} --type d . "$1"
      }
      export _fzf_compgen_dir
    '';
  };
}
