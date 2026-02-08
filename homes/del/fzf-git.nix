{pkgs, ...}: {
  programs.bash.initExtra = ''
    source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh
  '';
}
