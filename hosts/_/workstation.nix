_: {
  imports = [./flake-support.nix ./networkmanager.nix ./sops.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hardware.pulseaudio.enable = true;
  location.provider = "geoclue2";
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.fwupd.enable = true;
  services.sshd.enable = true;
  services.udisks2.enable = true;
  system.stateVersion = "22.11";
  time.timeZone = "Europe/Paris";
  users.users.del.extraGroups = ["networkmanager"];
}
