{pkgs, ...}:
with pkgs; {
  programs.rofi = {
    enable = true;
    terminal = "${wezterm}/bin/wezterm";
  };
}
