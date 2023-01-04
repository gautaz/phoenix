_: {
  xsession = {
    enable = true;

    initExtra = ''
      setxkbmap -option caps:escape
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };
  };
}
