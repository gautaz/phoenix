{pkgs}:
with pkgs;
  writeShellApplication {
    name = "outctl";
    runtimeInputs = [
      acpilight
      alsa-utils
      coreutils
      gawk
    ];
    text = builtins.readFile ./outctl.bash;
  }
