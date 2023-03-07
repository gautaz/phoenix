_: {
  imports = [./docker.nix ./flake-support.nix ./sops.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  hardware.pulseaudio.enable = true;
  location.provider = "geoclue2";
  networking.networkmanager.enable = true;
  services.fwupd.enable = true;
  services.sshd.enable = true;
  services.udisks2.enable = true;
  time.timeZone = "Europe/Paris";
  system.stateVersion = "22.11";
}
