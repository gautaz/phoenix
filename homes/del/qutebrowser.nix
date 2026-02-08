_: {
  programs.qutebrowser = {
    enable = true;

    extraConfig = ''
      config.unbind('d', mode='normal')
    '';

    keyBindings = {
      normal = {
        D = "tab-close";
      };
    };

    loadAutoconfig = true;

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      gth = "https://github.com/search?q={}";
      ggl = "https://www.google.com/search?hl=en&q={}";
      hmo = "https://home-manager-options.extranix.com/?query={}";
      map = "https://www.google.com/maps/search/?api=1&query={}";
      ngl = "https://noogle.dev/q?term={}";
      nxo = "https://search.nixos.org/options?channel=unstable&query={}";
      nxp = "https://search.nixos.org/packages?channel=unstable&query={}";
      wkp = "https://en.wikipedia.org/w/index.php?search={}";
    };

    settings = {
      auto_save.session = true;
      colors.webpage = {
        preferred_color_scheme = "light";
      };
      editor.command = ["alacritty" "-e" "vim" "-f" "{file}" "-c" "normal {line}G{column0}l"];
      tabs = {
        background = false;
        mousewheel_switching = false;
        # The following is a work around to avoid new tabs cluttering the pinned tab "group":
        # https://github.com/qutebrowser/qutebrowser/issues/2898#issuecomment-322009386
        new_position.related = "last";
      };
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
    };
    enable = true;
  };
}
