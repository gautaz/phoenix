_: {
  services = {
    displayManager = {
      enable = true;
      defaultSession = "none+xmonad";
    };

    libinput.touchpad = {
      clickMethod = "clickfinger";
      naturalScrolling = true;
      tapping = false;
    };

    xserver = {
      displayManager.lightdm.enable = true;
      enable = true;
      windowManager.xmonad.enable = true;
      xkb.options = "compose:ralt";
    };
  };
}
