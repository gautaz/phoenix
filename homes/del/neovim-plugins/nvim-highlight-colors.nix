{plugins, ...}: {
  config = "require('nvim-highlight-colors').setup{}";
  plugin = plugins.nvim-highlight-colors;
  type = "lua";
}
