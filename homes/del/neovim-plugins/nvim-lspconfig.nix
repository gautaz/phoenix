{
  pkgs,
  plugins,
  ...
}: let
  ngls = import ../../../modules/angular-language-server {inherit pkgs;};
in {
  config = builtins.readFile (pkgs.substituteAll {
    src = ./neovim-lspconfig.lua;
    dotnet = "${pkgs.dotnet-sdk}/bin/dotnet";
    omnisharpdll = "${pkgs.omnisharp-roslyn}/lib/omnisharp-roslyn/OmniSharp.dll";
    ngls = "${ngls."@angular/language-server-13.3.4"}/bin/ngserver";
  });
  plugin = plugins.nvim-lspconfig;
  type = "lua";
}
