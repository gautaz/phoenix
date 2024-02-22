_: {
  services.xserver = {
    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
    };
    enable = true;
    libinput.touchpad = {
      clickMethod = "clickfinger";
      naturalScrolling = true;
      tapping = false;
    };
    windowManager.xmonad.enable = true;
    xkb.options = "compose:ralt";
  };
}
