{pkgs, ...}: {
  networking.networkmanager = {
    dispatcherScripts = [
      {
        # based on https://askubuntu.com/a/112969
        source = pkgs.writeText "disable-wireless-when-wired" ''
          log() { logger -p user.info -t "disable-wireless-when-wired[$$]" "$*"; }
          IFACE=$1
          ACTION=$2

          case $IFACE in
            eth*|usb*|en*)
              case $ACTION in
                up)
                  log "disabling wifi radio"
                  ${pkgs.networkmanager}/bin/nmcli radio wifi off
                  ;;
                down)
                  log "enabling wifi radio"
                  ${pkgs.networkmanager}/bin/nmcli radio wifi on
                  ;;
              esac
              ;;
          esac
        '';
        type = "basic";
      }
    ];
    enable = true;
  };
  users.users.del.extraGroups = ["networkmanager"];
}
