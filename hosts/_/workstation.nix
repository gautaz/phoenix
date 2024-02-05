_: {
  imports = [./flake-support.nix ./networkmanager.nix ./sops.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hardware.pulseaudio.enable = true;
  location.provider = "geoclue2";
  services.avahi.enable = true;
  services.fwupd.enable = true;
  services.sshd.enable = true;
  services.udisks2.enable = true;
  time.timeZone = "Europe/Paris";
}
