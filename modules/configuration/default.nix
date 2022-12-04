{ pkgs, ... }:
with pkgs;
with builtins;
let
  generateConfiguration = writeShellApplication {
    name = "generateConfiguration";
    text = readFile ./generate.bash;
  };
in {
  environment.systemPackages = [
    generateConfiguration
  ];
}

