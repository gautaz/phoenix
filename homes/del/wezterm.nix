{pkgs, ...}: let
  latte = {
    rosewater = "#dc8a78";
    flamingo = "#dd7878";
    pink = "#ea76cb";
    mauve = "#8839ef";
    red = "#d20f39";
    maroon = "#e64553";
    peach = "#fe640b";
    yellow = "#df8e1d";
    green = "#40a02b";
    teal = "#179299";
    sky = "#04a5e5";
    sapphire = "#209fb5";
    blue = "#1e66f5";
    lavender = "#7287fd";
    text = "#4c4f69";
    subtext1 = "#5c5f77";
    subtext0 = "#6c6f85";
    overlay2 = "#7c7f93";
    overlay1 = "#8c8fa1";
    overlay0 = "#9ca0b0";
    surface2 = "#acb0be";
    surface1 = "#bcc0cc";
    surface0 = "#ccd0da";
    crust = "#dce0e8";
    mantle = "#e6e9ef";
    base = "#ffffff";
  };
in {
  home.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  fonts.fontconfig.enable = true;

  programs.wezterm = {
    colorSchemes.catppuccin-latte = {
      foreground = latte.text;
      background = latte.base;

      cursor_fg = latte.base;
      cursor_bg = latte.rosewater;
      cursor_border = latte.rosewater;

      selection_fg = latte.text;
      selection_bg = latte.surface2;

      scrollbar_thumb = latte.surface2;

      split = latte.overlay0;

      ansi = [
        latte.subtext1
        latte.red
        latte.green
        latte.yellow
        latte.blue
        latte.pink
        latte.teal
        latte.surface2
      ];

      brights = [
        latte.subtext0
        latte.red
        latte.green
        latte.yellow
        latte.blue
        latte.pink
        latte.teal
        latte.surface1
      ];

      indexed = {
        "16" = latte.peach;
        "17" = latte.rosewater;
      };

      compose_cursor = latte.flamingo;

      tab_bar = {
        background = latte.crust;
        active_tab = {
          bg_color = latte.mauve;
          fg_color = latte.crust;
        };
        inactive_tab = {
          bg_color = latte.mantle;
          fg_color = latte.text;
        };
        inactive_tab_hover = {
          bg_color = latte.base;
          fg_color = latte.text;
        };
        new_tab = {
          bg_color = latte.surface0;
          fg_color = latte.text;
        };
        new_tab_hover = {
          bg_color = latte.surface1;
          fg_color = latte.text;
        };
        inactive_tab_edge = latte.surface0;
      };

      visual_bell = latte.surface0;
    };

    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
