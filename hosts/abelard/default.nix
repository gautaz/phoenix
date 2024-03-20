_: {
  # dell P165G
  imports = [../_/development.nix ../_/hw/dell-laptop.nix ../_/workstation.nix];
  networking.hostName = "abelard";
  users.users.del.extraGroups = ["vboxusers"];
  virtualisation.multipass.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
