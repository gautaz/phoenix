{ pkgs, ... }:
with pkgs;
with builtins;
let
  mountStorage = writeShellApplication {
    name = "mount-host";
    text = readFile ./mount.bash;
  };
in
{ environment.systemPackages = [ mountStorage ]; }
