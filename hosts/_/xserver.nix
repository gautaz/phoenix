_: {
  services.xserver = {
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
    enable = true;
    libinput.touchpad = {
      naturalScrolling = true;
      tapping = false;
    };
    windowManager.xmonad.enable = true;
  };
}
