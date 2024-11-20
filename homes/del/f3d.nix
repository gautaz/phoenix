{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home = {
    file = {
      ".config/f3d/config.json".source = mkSymlink ./f3d.json;
    };
    packages = [
      pkgs.f3d
    ];
  };
}
