_: {
  imports = [./docker.nix];
  programs.wireshark.enable = true;
  users.users.del.extraGroups = ["vboxusers" "wireshark"];
  virtualisation.multipass.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
