{pkgs, ...}:
with pkgs;
with builtins; let
  setupStorage = writeShellApplication {
    name = "setup-storage";
    text = readFile ./setup.bash;
  };
  mountStorage = writeShellApplication {
    name = "mount-storage";
    text = readFile ./mount.bash;
  };
  umountStorage = writeShellApplication {
    name = "umount-storage";
    text = readFile ./umount.bash;
  };
in {
  environment.systemPackages = [
    jq # needed by setupStorage
    mountStorage
    setupStorage
    umountStorage
  ];
}
