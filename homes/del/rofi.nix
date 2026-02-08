{pkgs, ...}:
with pkgs; {
  programs.rofi = {
    enable = true;
    terminal = "${alacritty}/bin/alacritty";
  };
}
