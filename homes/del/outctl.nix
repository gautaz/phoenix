{pkgs, ...}: let
  outctl = import ./outctl-app.nix {inherit pkgs;};
in {
  home.packages = [
    outctl
  ];
}
