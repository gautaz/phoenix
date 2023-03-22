_: {
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      config.unbind('d', mode='normal')
    '';
    loadAutoconfig = true;
    settings = {
      auto_save.session = true;
      editor.command = ["alacritty" "-e" "vim" "-f" "{file}" "-c" "normal {line}G{column0}l"];
    };
  };
}
