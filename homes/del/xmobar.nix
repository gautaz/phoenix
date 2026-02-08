{pkgs, ...}: {
  home.packages = [
    pkgs.iosevka
  ];
  programs.xmobar = {
    enable = true;
    extraConfig = builtins.readFile ./xmobarrc;
  };
}
