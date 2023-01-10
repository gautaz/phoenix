{pkgs, ...}: {
  imports = [../_/flake-support.nix ../_/hw/framework.nix ../_/storage.nix ./autorandr.nix];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "hepao";
  networking.networkmanager.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = true;
      };
      windowManager.xmonad.enable = true;
    };
  };

  time.timeZone = "Europe/Paris";

  users.users.del = {
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [home-manager];
  };

  system.stateVersion = "22.11";
}
