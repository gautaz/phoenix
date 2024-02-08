_: {
  # dell P165G
  imports = [../_/development.nix ../_/hw/dell-laptop.nix ../_/workstation.nix];
  networking.hostName = "abelard";
  virtualisation.multipass.enable = true;
}
