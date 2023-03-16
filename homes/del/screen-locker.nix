{pkgs, ...}:
with pkgs; let
  xdimmer = writeShellApplication {
    name = "xdimmer";
    text = ''
      export XSECURELOCK_DIM_ALPHA=1
      "${xsecurelock}/libexec/xsecurelock/dimmer" "$@"
    '';
  };
  xlocker = writeShellApplication {
    name = "xlocker";
    text = ''
      export XSECURELOCK_PASSWORD_PROMPT=time_hex
      "${xsecurelock}/bin/xsecurelock" "$@"
    '';
  };
in {
  home.packages = [
    xlocker
    xsecurelock
  ];

  services.screen-locker = {
    enable = true;
    inactiveInterval = 3;
    lockCmd = "${xlocker}/bin/xlocker";
    xautolock.enable = false;
    xss-lock = {
      extraOptions = ["-n" "${xdimmer}/bin/xdimmer" "-l"];
      screensaverCycle = 5; # https://github.com/nix-community/home-manager/issues/2852
    };
  };
}
