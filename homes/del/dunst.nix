{pkgs, ...}: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Tango";
      package = pkgs.tango-icon-theme;
      size = "48x48";
    };
  };
}
