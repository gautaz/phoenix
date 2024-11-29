{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.ubuntu-mono
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        bright = {
          black = "#4f525e";
          blue = "#61afef";
          cyan = "#56b6c2";
          green = "#98c379";
          magenta = "#c678dd";
          red = "#e06c75";
          white = "#ffffff";
          yellow = "#e5c07b";
        };
        cursor = {
          cursor = "#bfceff";
          text = "#383a42";
        };
        normal = {
          black = "#383a42";
          blue = "#0184bc";
          cyan = "#0997b3";
          green = "#50a14f";
          magenta = "#a626a4";
          red = "#e45649";
          white = "#fafafa";
          yellow = "#c18401";
        };
        primary = {
          background = "#fafafa";
          foreground = "#383a42";
        };
        selection = {
          background = "#bfceff";
          text = "#383a42";
        };
      };
      cursor = {
        style = {
          blinking = "Always";
        };
        blink_interval = 500;
        blink_timeout = 0;
      };
      env = {
        WINIT_X11_SCALE_FACTOR = "1.5";
      };
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
