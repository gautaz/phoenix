{pkgs, ...}: {
  home = {
    file = {
      ".config/f3d/config.json".source = ./f3d.json;
    };
    packages = [
      pkgs.f3d
    ];
  };
}
