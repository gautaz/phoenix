{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with builtins;
let
  nimBuild = writeShellApplication {
    name = "nim-build";
    text = readFile ./shell/build.bash;
  };
  nimMount = writeShellApplication {
    name = "nim-mount";
    text = readFile ./shell/mount.bash;
  };
  nimTest = writeShellApplication {
    name = "nim-test";
    text = readFile ./shell/test.bash;
  };
  nimUmount = writeShellApplication {
    name = "nim-umount";
    text = readFile ./shell/mount.bash;
  };
in pkgs.mkShell {
  name = "NIM-shell";
  packages = [
    cryptsetup
    git
    git-lfs
    less
    kmod
    mount
    nimBuild
    nimMount
    nimTest
    nimUmount
    nix
    OVMF
    qemu
    umount
  ];
  shellHook = "alias sudo=/run/wrappers/bin/sudo";
}
