{plugins, ...}: {
  config = "require('feline').setup{}";
  plugin = plugins.feline-nvim;
  type = "lua";
}
