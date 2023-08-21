_: {
  imports = [./flake-support.nix ./networkmanager.nix ./sops.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hardware.i2c.enable = true;
  hardware.pulseaudio.enable = true;
  location.provider = "geoclue2";
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.ddccontrol.enable = true;
  services.fwupd.enable = true;
  services.sshd.enable = true;
  services.udisks2.enable = true;
  time.timeZone = "Europe/Paris";
  users.users.del.extraGroups = ["networkmanager"];
}
