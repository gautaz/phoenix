{pkgs, ...}: let
  outctl = import ./_/outctl.nix {inherit pkgs;};
  xlocker = import ./_/xlocker.nix {inherit pkgs;};

  wallpaper = builtins.path {
    name = "wallpaper";
    path = ./wallpapers/tree.jpg;
  };

  refreshBackground = with pkgs;
    writeShellApplication {
      name = "refreshBackground";
      runtimeInputs = [
        feh
        wallpaper
      ];
      text = "feh --bg-fill --geometry +0+0 ${wallpaper}";
    };

  ropass = with pkgs;
    writeShellApplication {
      name = "ropass";
      runtimeInputs = [
        findutils
        gnused
        passage
      ];
      text = ''
        PASS_STORE="$HOME/.passage/store"
        passage -c "$(find "$PASS_STORE" -type f -name '*.age' | sed -e "s#^$PASS_STORE/\(.*\)\.age\$#\1#" | rofi -dmenu)"
      '';
    };

  rorandr = with pkgs;
    writeShellApplication {
      name = "rorandr";
      runtimeInputs = [
        findutils
        refreshBackground
        rofi
      ];
      text = ''
        LAYOUTDIR="$HOME/.screenlayout"
        # shellcheck source=/dev/null
        . "$LAYOUTDIR/$(find "$LAYOUTDIR" -type f -printf "%P\n" | rofi -monitor -1 -dmenu)"
        refreshBackground
      '';
    };
in {
  xsession = {
    enable = true;

    initExtra = ''
      ${refreshBackground}/bin/refreshBackground
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.substituteAll {
        src = ./xmonad.hs;

        alacritty = "${pkgs.alacritty}/bin/alacritty";
        colorswitch = "${pkgs.xrandr-invert-colors}/bin/xrandr-invert-colors";
        findcursor = "${pkgs.find-cursor}/bin/find-cursor";
        flameshot = "${pkgs.flameshot}/bin/flameshot";
        outctl = "${outctl}/bin/outctl";
        rofi = "${pkgs.rofi}/bin/rofi";
        ropass = "${ropass}/bin/ropass";
        rorandr = "${rorandr}/bin/rorandr";
        systemctl = "${pkgs.systemd}/bin/systemctl";
        xlocker = "${xlocker}/bin/xlocker";
        xmobar = "${pkgs.xmobar}/bin/xmobar";
      };
    };
  };
}
