# This module should comply with the storage layout set up by:
# https://github.com/gautaz/nixos-install-media
{ config, lib, pkgs, modulesPath, ... }: {
  boot.initrd.luks.devices.pv.device = "/dev/disk/by-label/pv";

  fileSystems."/" = {
    device = "/dev/mapper/vg-system";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/vg-system";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/vg-system";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  swapDevices = [ { device = "/dev/mapper/vg-swap"; } ];
}
