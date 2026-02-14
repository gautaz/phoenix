{plugins, ...}: {
  config = builtins.readFile ./hlchunk-nvim.lua;
  plugin = plugins.hlchunk-nvim;
  type = "lua";
}
