{pkgs, ...}: {
  home = {
    file = {
      ".config/f3d/config.json".source = ./f3d.json;
    };
    packages = [
      pkgs.f3d
    ];
  };

  xdg.mimeApps = {
    defaultApplications = {
      "model/3mf" = "f3d-plugin-assimp.desktop";
    };
    enable = true;
  };
}
