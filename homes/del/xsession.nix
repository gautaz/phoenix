{pkgs, ...}: {
  xsession = {
    enable = true;

    initExtra = ''
      feh --bg-fill https://i.pinimg.com/originals/9c/7c/d1/9c7cd145bb18704a1813dcdd5356b1cf.jpg
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.substituteAll {
        src = ./xmonad.hs;

        alacritty = "${pkgs.alacritty}/bin/alacritty";
        rofi = "${pkgs.rofi}/bin/rofi";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        xlocker = "${pkgs.xsecurelock}/bin/xsecurelock";
        xmobar = "${pkgs.xmobar}/bin/xmobar";
      };
    };
  };
}
