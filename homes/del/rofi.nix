{pkgs, ...}:
with pkgs; {
  programs.rofi = {
    enable = true;
    settings.terminal = "${wezterm}/bin/wezterm";
  };
}
