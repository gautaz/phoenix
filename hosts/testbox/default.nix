_: {
  imports = [../_/hw/qemu.nix ../_/storage.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "testbox";
  time.timeZone = "Europe/Paris";
}
