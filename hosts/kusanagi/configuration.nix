{ config, pkgs, ... }: {
  imports = [
    ../_/hw/qemu.nix
    ../_/storage.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "kusanagi";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
    windowManager.xmonad.enable = true;
  };

  time.timeZone = "Europe/Paris";

  users.users.del = {
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [
      home-manager
    ];
  };

  system.stateVersion = "22.11";
}
