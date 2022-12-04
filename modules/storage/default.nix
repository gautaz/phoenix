{ pkgs, ... }:
with pkgs;
with builtins;
let
  setupStorage = writeShellApplication {
    name = "setupStorage";
    text = readFile ./setup.bash;
  };
  mountStorage = writeShellApplication {
    name = "mountStorage";
    text = readFile ./mount.bash;
  };
  umountStorage = writeShellApplication {
    name = "umountStorage";
    text = readFile ./umount.bash;
  };
in {
  environment.systemPackages = [
    jq
    mountStorage
    setupStorage
    umountStorage
  ];
}
