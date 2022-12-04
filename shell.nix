{ pkgs ? import <nixpkgs> {} }:
with pkgs;
with builtins;
let
  nimBuild = writeShellApplication {
    name = "nimBuild";
    text = readFile ./shell/build.bash;
  };
  nimTest = writeShellApplication {
    name = "nimTest";
    text = readFile ./shell/test.bash;
  };
in pkgs.mkShell {
  name = "NIM-shell";
  packages = [
    git
    git-lfs
    less
    nimBuild
    nimTest
    nix
    qemu
  ];
}
