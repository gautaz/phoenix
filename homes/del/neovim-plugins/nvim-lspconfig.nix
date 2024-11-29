{
  pkgs,
  plugins,
  ...
}: {
  config = builtins.readFile (pkgs.substituteAll {
    src = ./neovim-lspconfig.lua;

    dotnet = "${pkgs.dotnet-sdk}/bin/dotnet";
    omnisharpdll = "${pkgs.omnisharp-roslyn}/lib/omnisharp-roslyn/OmniSharp.dll";
  });
  plugin = plugins.nvim-lspconfig;
  type = "lua";
}
