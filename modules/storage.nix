{ pkgs, ... }:
with pkgs;
with builtins;
let
  setupLocalStorage = writeShellApplication {
    name = "setupStorage";
    text = readFile ./setupStorage.bash;
  };
in {
  environment.systemPackages = [
    setupLocalStorage
  ];
}
