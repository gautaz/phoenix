{pkgs, ...}: let
  regen-yt-dlp-cookies = with pkgs;
    writeShellApplication {
      name = "regen-yt-dlp-cookies";
      runtimeInputs = [sqlite];
      text = builtins.readFile ./regen-yt-dlp-cookies.bash;
    };
in {
  home.packages = [regen-yt-dlp-cookies];
}
