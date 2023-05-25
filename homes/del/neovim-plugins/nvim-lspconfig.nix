{
  pkgs,
  plugins,
  ...
}: {
  config = builtins.readFile (pkgs.substituteAll {
    src = ./neovim-lspconfig.lua;
    csharpls = "${pkgs.csharp-ls}/bin/CSharpLanguageServer";
  });
  plugin = plugins.nvim-lspconfig;
  type = "lua";
}
