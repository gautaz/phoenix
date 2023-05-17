{pkgs, ...}: {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["UbuntuMono"];})
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        name = "One Half Light";
        author = "https://github.com/mbadolato/iTerm2-Color-Schemes/blob/67f9d9472dc2a321cf0fb78079d85ed76e2e173e/alacritty/OneHalfLight.yml";
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
          selection = {
            background = "#bfceff";
            text = "#383a42";
          };
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
