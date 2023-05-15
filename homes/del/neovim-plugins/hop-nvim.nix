{plugins, ...}: {
  config = builtins.readFile ./hop-nvim.lua;
  plugin = plugins.hop-nvim;
  type = "lua";
}
