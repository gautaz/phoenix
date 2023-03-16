{pkgs, ...}:
with pkgs; let
  outctl = writeShellApplication {
    name = "outctl";
    runtimeInputs = [
      acpilight
      alsa-utils
      coreutils
      gawk
    ];
    text = builtins.readFile ./outctl.bash;
  };
in {
  home.packages = [
    outctl
  ];
}
