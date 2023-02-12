{pkgs, ...}: {
  home.packages = with pkgs; [
    xsecurelock
  ];

  services.screen-locker = {
    enable = true;
    inactiveInterval = 3;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    xss-lock.extraOptions = ["-n" "${pkgs.xsecurelock}/libexec/xsecurelock/dimmer" "-l"];
  };
}
