{pkgs, ...}: {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["UbuntuMono"];})
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        cursor = {
          cursor = "#ffffff";
          text = "#000000";
        };
      };
      cursor = {
        style = {
          blinking = "Always";
        };
        blink_interval = 500;
        blink_timeout = 0;
      };
      dynamic_title = true;
      font = {
        normal = {
          family = "UbuntuMono Nerd Font";
          style = "Regular";
        };
        size = 10.0;
      };
    };
  };
}
