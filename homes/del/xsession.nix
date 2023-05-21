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
      text = "${feh}/bin/feh --bg-fill --geometry +0+0 ${wallpaper}";
    };

  rorandr = with pkgs;
    writeShellApplication {
      name = "rorandr";
      runtimeInputs = [findutils];
      text = ''
        LAYOUTDIR="$HOME/.screenlayout"
        # shellcheck source=/dev/null
        . "$LAYOUTDIR/$(${findutils}/bin/find "$LAYOUTDIR" -type f -printf "%P\n" | ${rofi}/bin/rofi -monitor -1 -dmenu)"
        ${refreshBackground}/bin/refreshBackground
      '';
    };
in {
  home.packages = [pkgs.xrandr-invert-colors];
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
