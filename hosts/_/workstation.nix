{lib, ...}: {
  imports = [./flake-support.nix ./i2c.nix ./networkmanager.nix ./sops.nix ./sound.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };
  location.provider = "geoclue2";
  networking = {
    useDHCP = lib.mkDefault true;
  };
  services = {
    avahi.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };

    # https://github.com/NixOS/nixpkgs/issues/298150#issuecomment-2016658808
    # https://nixpk.gs/pr-tracker.html?pr=298491
    fprintd.enable = false;

    fwupd.enable = true;
    sshd.enable = true;
    tzupdate.enable = true;
    udisks2.enable = true;
  };
}
