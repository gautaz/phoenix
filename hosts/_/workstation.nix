_: {
  imports = [../_/flake-support.nix ../_/sops.nix ../_/storage.nix ../_/users.nix ../_/xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  networking.networkmanager.enable = true;
  services.fwupd.enable = true;
  services.sshd.enable = true;
  time.timeZone = "Europe/Paris";
  system.stateVersion = "22.11";
}
