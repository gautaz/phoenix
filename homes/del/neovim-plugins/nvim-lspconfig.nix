{
  pkgs,
  plugins,
  ...
}: {
  config = builtins.readFile ./neovim-lspconfig.lua;
  plugin = plugins.nvim-lspconfig;
  type = "lua";
}
