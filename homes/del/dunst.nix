{pkgs, ...}: {
  home.packages = with pkgs; [
    libnotify # provides notify-send to test dunst
  ];

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Tango";
      package = pkgs.tango-icon-theme;
      size = "48x48";
    };
  };
}
