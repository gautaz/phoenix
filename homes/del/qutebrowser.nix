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
        preferred_color_scheme = "light";
      };
      editor.command = ["alacritty" "-e" "vim" "-f" "{file}" "-c" "normal {line}G{column0}l"];
      # The following is a work around to avoid new tabs cluttering the pinned tab "group":
      # https://github.com/qutebrowser/qutebrowser/issues/2898#issuecomment-322009386
      tabs.new_position.related = "last";
    };
  };
}
