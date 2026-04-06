{pkgs}:
with pkgs;
  writeShellApplication {
    name = "outctl";
    runtimeInputs = [
      acpilight
      alsa-utils
      coreutils
      ddcutil
      gawk
      gnugrep
      gnused
      xdg-user-dirs
    ];
    text = builtins.readFile ./outctl.bash;
  }
