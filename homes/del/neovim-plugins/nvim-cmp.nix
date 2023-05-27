{plugins, ...}: {
  config = builtins.readFile ./nvim-cmp.lua;
  plugin = plugins.nvim-cmp;
  type = "lua";
}
