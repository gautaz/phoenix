{pkgs, ...}: {
  home.packages = [
    pkgs.mpc
  ];
  services = {
    mpd = {
      enable = true;
      network.startWhenNeeded = true;
    };
  };
}
