{pkgs, ...}: let
  outctl = import ./_/outctl.nix {inherit pkgs;};
in {
  home.packages = [
    outctl
  ];
}
