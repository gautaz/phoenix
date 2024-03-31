{pkgs, ...}:
with pkgs; let
  xdimmer = writeShellApplication {
    name = "xdimmer";
    runtimeInputs = [
      xsecurelock
    ];
    text = ''
      export XSECURELOCK_DIM_ALPHA=1
      exec "${xsecurelock}/libexec/xsecurelock/dimmer" "$@"
    '';
  };
  xlocker = import ./_/xlocker.nix {inherit pkgs;};
in {
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
