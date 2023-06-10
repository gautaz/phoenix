{plugins, ...}: {
  config = "require('fidget').setup{}";
  plugin = plugins.fidget-nvim;
  type = "lua";
}
