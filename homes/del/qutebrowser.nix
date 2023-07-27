{pkgs, ...}: {
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

    package = pkgs.qutebrowser-qt6.overrideAttrs (_: {
      src = pkgs.fetchgit {
        url = "https://github.com/qutebrowser/qutebrowser.git";
        rev = "6d84462d68ec1ce4cde459297e0c52ad3c2bf29f";
        sha256 = "sha256-oAjhzTeZ7TNBR6lxBpNdDGJHnTdnWU16lZtlrvZhfE0=";
      };
    });

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      go = "https://www.google.com/search?hl=en&q={}";
      gh = "https://github.com/search?q={}";
      nh = "https://mipmip.github.io/home-manager-option-search/?query={}";
      no = "https://search.nixos.org/options?channel=unstable&query={}";
      np = "https://search.nixos.org/packages?channel=unstable&query={}";
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
}
