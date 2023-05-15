{plugins, ...}: {
  config = "require('gitsigns').setup{}";
  plugin = plugins.gitsigns-nvim;
  type = "lua";
}
