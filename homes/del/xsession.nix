_: {
  xsession = {
    enable = true;

    initExtra = ''
      setxkbmap -option caps:super
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };
}
