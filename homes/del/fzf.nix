{pkgs, ...}:
with pkgs; let
  fzfCommand = "${fd}/bin/fd --follow --exclude \".git\"";
in {
  home.packages = [
    fd
  ];

  programs = {
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

    fzf = {
      defaultCommand = "${fzfCommand}";
      defaultOptions = [
        "--preview 'interview {}'"
      ];
      enable = true;
      enableBashIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
