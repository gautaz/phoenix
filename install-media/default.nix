{pkgs, ...}:
with pkgs; {
  imports = [../modules/qemu-mount-host ./configuration ./iso.nix ./storage];
  environment.systemPackages = [
    git # needed by nixos-install --flake
  ];
}
