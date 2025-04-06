_: {
  networking = {
    hostName = "echidna";
    networkmanager.enable = true;
  };
  services.openssh.enable = true;
  time.timeZone = "Europe/Paris";
  users.users.pi = {
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "raspberry";
    isNormalUser = true;
  };
}
