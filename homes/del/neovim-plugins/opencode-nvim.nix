{
  pkgs,
  plugins,
  ...
}: let
  template = builtins.readFile ./opencode-nvim.lua;
in {
  config =
    builtins.replaceStrings [
      "@bash@"
      "@ocv@"
    ] [
      "${pkgs.bash}/bin/bash"
      "${pkgs.opencode}/bin/opencode"
    ]
    template;
  plugin = plugins.opencode-nvim;
  type = "lua";
}
