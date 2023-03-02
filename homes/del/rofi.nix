{pkgs, ...}:
with pkgs; {
  home = {
    file.".config/rofi/file-browser".text = ''
      resume
    '';

    packages = [
      wmctrl # used by rofi to interact with the window manager
    ];
  };

  programs.rofi = {
    enable = true;
    package = rofi.override {plugins = [rofi-file-browser];};
    terminal = "${alacritty}/bin/alacritty";
  };
}
