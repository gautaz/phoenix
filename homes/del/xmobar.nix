{pkgs, ...}:
with pkgs; let
  xmobar-gpu-meter = writeShellApplication {
    name = "xmobar-gpu-meter";
    runtimeInputs = [
      coreutils
    ];
    text = builtins.readFile ./xmobar-gpu-meter.bash;
  };

  xmobarrc = builtins.readFile ./xmobarrc;
in {
  home.packages = [
    pkgs.google-fonts
  ];

  fonts.fontconfig.enable = true;

  programs.xmobar = {
    enable = true;
    extraConfig =
      builtins.replaceStrings
      ["@gpuMeter@"]
      ["${xmobar-gpu-meter}/bin/xmobar-gpu-meter"]
      xmobarrc;
  };
}
