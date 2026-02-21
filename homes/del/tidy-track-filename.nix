{pkgs, ...}: let
  tidy-track-filename = with pkgs;
    writeShellApplication {
      name = "tidy-track-filename";
      runtimeInputs = [coreutils];
      text = builtins.readFile ./tidy-track-filename.bash;
    };
in {
  home.packages = [tidy-track-filename];
}
