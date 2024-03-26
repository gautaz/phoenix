_: {
  networking.hostName = "echidna";
  services.openssh.enable = true;
  time.timeZone = "Europe/Paris";
  users.users.pi = {
    extraGroups = ["wheel"];
    initialPassword = "raspberry";
    isNormalUser = true;
  };
}
