{plugins, ...}: {
  config = builtins.readFile ./catppuccin-nvim.lua;
  plugin = plugins.catppuccin-nvim;
  type = "lua";
}
