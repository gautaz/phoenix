{pkgs, ...}: {
  home.packages = [
    pkgs.google-fonts
  ];
  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile ./xmobarrc;
  };
}
