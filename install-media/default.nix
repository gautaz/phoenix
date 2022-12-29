{ pkgs, ... }:
with pkgs; {
  imports = [ ./configuration ./host ./iso.nix ./storage ];
  environment.systemPackages = [
    git # needed by nixos-install --flake
  ];
}
