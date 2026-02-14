{pkgs, ...}:
with pkgs; let
  interview = writeShellApplication {
    name = "interview";
    runtimeInputs = [
      bat
      chafa
      coreutils
      file
      mpv
      poppler-utils
      tree
    ];
    text = builtins.readFile ./interview.sh;
  };
in {
  home.packages = [interview];
}
