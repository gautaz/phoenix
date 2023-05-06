{pkgs, ...}:
with pkgs; let
  autorandrDebounce = writeShellApplication {
    name = "autorandr-debounce";
    runtimeInputs = [
      coreutils
    ];
    text = ''
      PIDFILE="/run/user/$(id -u)/autorandr-debounce.pid"
      echo -n "$$" > "$PIDFILE"
      sleep 15
      if [ "$$" -eq "$(cat "$PIDFILE")" ]; then
        rm "$PIDFILE"
      else
        echo "Debouncing autorandr event" 1>&2
        exit 11
      fi
    '';
  };

  displayFingerprint = {
    DP-4-1 = "00ffffffffffff0010ace34157304c45191f010380351e78eeee95a3544c99260f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00423259435738330a2020202020000000fc0044454c4c20553234323148450a000000fd00384c1e5a11000a2020202020200143020322f14f90050403020716010611121513141f23097f078301000065030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000180000000000000000000000000000000000000000008d";
    DP-4-2 = "00ffffffffffff004c2d350d43545a42241d0104a54627783a64a5a4544d9a260f5054230800b30081c0810081809500a9c001010101023a801871382d40582c4500ba892100001e000000fd00383c1e5111000a202020202020000000fc00433332463339310a2020202020000000ff0048345a4d3930303130390a202001e902030ff14290042309070783010000011d007251d01e206e285500ba892100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b";
    eDP-1 = "00ffffffffffff0009e55f0900000000171d0104a51c137803de50a3544c99260f505400000001010101010101010101010101010101115cd01881e02d50302036001dbe1000001aa749d01881e02d50302036001dbe1000001a000000fe00424f452043510a202020202020000000fe004e4531333546424d2d4e34310a00fb";
  };
in {
  environment.systemPackages = [autorandrDebounce];

  services.autorandr = {
    defaultTarget = "mobile";
    enable = true;
    hooks.predetect = {
      debounce = "${autorandrDebounce}/bin/autorandr-debounce";
    };
    profiles = {
      homeDock = {
        config = {
          DP-1.enable = false;
          DP-2.enable = false;
          DP-3.enable = false;
          DP-4.enable = false;
          DP-4-1 = {
            crtc = 1;
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            primary = false;
            rate = "60.00";
            rotate = "right";
          };
          DP-4-2 = {
            crtc = 2;
            enable = true;
            mode = "1920x1080";
            position = "1080x264";
            primary = true;
            rate = "60.00";
          };
          eDP-1 = {
            crtc = 0;
            enable = true;
            mode = "1680x1050";
            position = "3000x264";
            primary = false;
            rate = "59.95";
          };
        };
        fingerprint = {
          inherit (displayFingerprint) DP-4-1;
          inherit (displayFingerprint) DP-4-2;
          inherit (displayFingerprint) eDP-1;
        };
      };

      mobile = {
        config = {
          DP-1.enable = false;
          DP-2.enable = false;
          DP-3.enable = false;
          DP-4.enable = false;
          DP-4-1.enable = false;
          DP-4-2.enable = false;
          eDP-1 = {
            crtc = 0;
            enable = true;
            mode = "2256x1504";
            position = "0x0";
            primary = true;
            rate = "60.00";
          };
        };
        fingerprint = {
          inherit (displayFingerprint) eDP-1;
        };
      };
    };
  };
}
