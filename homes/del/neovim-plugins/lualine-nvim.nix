{plugins, ...}: {
  config = builtins.readFile ./lualine-nvim.lua;
  plugin = plugins.lualine-nvim;
  type = "lua";
}
