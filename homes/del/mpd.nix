{pkgs, ...}: {
  home.packages = [
    pkgs.mpc
  ];
  services = {
    mpd = {
      enable = true;
      network.startWhenNeeded = true;
      musicDirectory = "/home/del/Music";
      playlistDirectory = "/home/del/Music/Playlists";
    };
  };
}
