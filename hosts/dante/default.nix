_: {
  # dell P117F
  imports = [../_/development.nix ../_/hw/dell-laptop.nix ../_/workstation.nix];
  networking.hostName = "dante";
}
