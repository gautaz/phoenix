{lib, ...}: {
  imports = [./flake-support.nix ./networkmanager.nix ./sops.nix ./sound.nix ./storage.nix ./users.nix ./xserver.nix];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  location.provider = "geoclue2";
  networking = {
    useDHCP = lib.mkDefault true;
  };
  services = {
    avahi.enable = true;

    # https://github.com/NixOS/nixpkgs/issues/298150#issuecomment-2016658808
    # https://nixpk.gs/pr-tracker.html?pr=298491
    fprintd.enable = false;

    fwupd.enable = true;
    sshd.enable = true;
    udisks2.enable = true;
  };
  time.timeZone = "Europe/Paris";
}
