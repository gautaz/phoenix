{pkgs, ...}:
with pkgs; {
  home.packages = [
    wmctrl # used by rofi to interact with the window manager
  ];
  programs.rofi = {
    enable = true;
    terminal = "${alacritty}/bin/alacritty";
  };
}
