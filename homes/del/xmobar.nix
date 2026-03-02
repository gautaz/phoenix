{pkgs, ...}: {
  home.packages = [
    pkgs.google-fonts
  ];

  fonts.fontconfig.enable = true;

  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile ./xmobarrc;
  };
}
