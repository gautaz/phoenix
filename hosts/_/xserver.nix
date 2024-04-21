_: {
  services = {
    displayManager = {
      enable = true;
      defaultSession = "none+xmonad";
    };

    xserver = {
      displayManager.lightdm.enable = true;
      enable = true;
      libinput.touchpad = {
        clickMethod = "clickfinger";
        naturalScrolling = true;
        tapping = false;
      };
      windowManager.xmonad.enable = true;
      xkb.options = "compose:ralt";
    };
  };
}
