_: {
  programs.qutebrowser = {
    enable = true;
    settings = {
      auto_save.session = true;
      editor.command = ["alacritty" "-e" "vim" "-f" "{file}" "-c" "normal {line}G{column0}l"];
    };
  };
}
