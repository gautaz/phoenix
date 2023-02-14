{pkgs, ...}: let
  outctl = pkgs.writeShellApplication {
    name = "outctl";
    text = builtins.readFile ./outctl.bash;
  };
  outctlOSD = pkgs.writeShellApplication {
    name = "outctl-osd";
    text = ''
      PATH="$PATH:${pkgs.coreutils}/bin:${pkgs.netcat}/bin:${pkgs.xosd}/bin"
      rm -f ~/.outctl-osd.socket
      (
        umask 77
        nc -klU ~/.outctl-osd.socket \
        | osd_cat \
          --align=center \
          --delay=2 \
          --font="-*-courier-bold-r-*-*-34-*-*-*-*-*-*-*" \
          --lines=1 \
          --offset=100 \
          --pos=bottom
      )
    '';
  };
in {
  home.packages = with pkgs; [
    alsa-utils
    netcat
    outctl
    xosd
  ];
  systemd.user.services.outctl-osd = {
    Unit.Description = "On Screen Display service for output controls";
    Service = {
      ExecStart = "${outctlOSD}/bin/outctl-osd";
      Restart = true;
    };
  };
}
