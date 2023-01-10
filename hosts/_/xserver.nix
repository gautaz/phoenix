_: {
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
    windowManager.xmonad.enable = true;
  };
}
