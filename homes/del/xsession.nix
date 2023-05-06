{pkgs, ...}: let
  outctl = import ./_/outctl.nix {inherit pkgs;};
  xlocker = import ./_/xlocker.nix {inherit pkgs;};

  refreshBackground = "feh --bg-fill https://i.pinimg.com/originals/9c/7c/d1/9c7cd145bb18704a1813dcdd5356b1cf.jpg";
  rorandr = with pkgs;
    writeShellApplication {
      name = "rorandr";
      runtimeInputs = [findutils];
      text = ''
        LAYOUTDIR="$HOME/.screenlayout"
        # shellcheck source=/dev/null
        . "$LAYOUTDIR/$(${findutils}/bin/find "$LAYOUTDIR" -type f -printf "%P\n" | ${rofi}/bin/rofi -monitor -1 -dmenu)"
        ${refreshBackground}
      '';
    };
in {
  xsession = {
    enable = true;

    initExtra = ''
      ${refreshBackground}
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.substituteAll {
        src = ./xmonad.hs;

        alacritty = "${pkgs.alacritty}/bin/alacritty";
        flameshot = "${pkgs.flameshot}/bin/flameshot";
        outctl = "${outctl}/bin/outctl";
        rofi = "${pkgs.rofi}/bin/rofi";
        rorandr = "${rorandr}/bin/rorandr";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        xlocker = "${xlocker}/bin/xlocker";
        xmobar = "${pkgs.xmobar}/bin/xmobar";
      };
    };
  };
}
