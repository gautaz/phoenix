_: {
  networking.networkmanager.enable = true;
  users.users.del.extraGroups = ["networkmanager"];
}
