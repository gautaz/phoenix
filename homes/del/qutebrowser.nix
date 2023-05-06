_: {
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      config.unbind('d', mode='normal')
    '';
    loadAutoconfig = true;
    settings = {
      auto_save.session = true;
      colors.webpage = {
        darkmode.enabled = true;
        preferred_color_scheme = "dark";
      };
      editor.command = ["alacritty" "-e" "vim" "-f" "{file}" "-c" "normal {line}G{column0}l"];
    };
  };
}
