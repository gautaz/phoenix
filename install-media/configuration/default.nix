{ pkgs, ... }:
with pkgs;
with builtins;
let
  generateConfiguration = writeShellApplication {
    name = "generate-configuration";
    text = readFile ./generate.bash;
  };
in {
  environment.systemPackages = [
    generateConfiguration
  ];
}
