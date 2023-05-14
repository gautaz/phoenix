{pkgs, ...}: {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["UbuntuMono"];})
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      # https://gitlab.com/protesilaos/tempus-themes
      # https://gitlab.com/protesilaos/tempus-themes-alacritty/-/blob/199e8620e336c6159ab867e2093614b61d876944/tempus_fugit.yml
      colors = {
        name = "Tempus Fugit";
        author = "Protesilaos Stavrou (https://protesilaos.com)";
        description = "Light, pleasant theme optimised for long writing/coding sessions (WCAG AA compliant)";
        primary = {
          foreground = "#4d595f";
          background = "#fff5f3";
        };
        cursor = {
          text = "#fff5f3";
          cursor = "#4d595f";
        };
        selection = {
          text = "#fff5f3";
          background = "#4d595f";
        };
        normal = {
          black = "#4d595f";
          red = "#c61a14";
          green = "#357200";
          yellow = "#825e00";
          blue = "#1666b0";
          magenta = "#a83884";
          cyan = "#007072";
          white = "#efe6e4";
        };
        bright = {
          black = "#796271";
          red = "#b93f1a";
          green = "#437520";
          yellow = "#985900";
          blue = "#485adf";
          magenta = "#a234c0";
          cyan = "#00756a";
          white = "#fff5f3";
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
