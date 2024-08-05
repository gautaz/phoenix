_: {
  boot.kernelPatches = [
    {
      name = "kernel-debug";
      patch = null;
      extraConfig = ''
        GDB_SCRIPTS y
      '';
    }
  ];
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
