_: {
  imports = [./flake-support.nix ./networkmanager.nix ./sops.nix ./sound.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  location.provider = "geoclue2";
  services = {
    avahi.enable = true;
    fwupd.enable = true;
    sshd.enable = true;
    udisks2.enable = true;
  };
  time.timeZone = "Europe/Paris";
}
