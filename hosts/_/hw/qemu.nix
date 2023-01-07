{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix") ../../../modules/qemu-mount-host];
  boot.extraModulePackages = [];
  boot.initrd.availableKernelModules = ["ata_piix" "virtio_pci" "floppy" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
