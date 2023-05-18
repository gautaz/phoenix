{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      config.unbind('d', mode='normal')
    '';
    loadAutoconfig = true;
    package = pkgs.qutebrowser-qt6.overrideAttrs (_: {
      src = pkgs.fetchgit {
        url = "https://github.com/qutebrowser/qutebrowser.git";
        rev = "04c64b7430bbb1cee64927541da8b8fae75c92e3";
        sha256 = "sha256-xUjesizJ73JBqU151uJo3o5O2mMU/gyRlcreg7nXlmI=";
      };
    });
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
