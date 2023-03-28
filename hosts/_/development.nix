_: {
  imports = [./docker.nix];
  programs.wireshark.enable = true;
  users.users.del.extraGroups = ["wireshark"];
}
