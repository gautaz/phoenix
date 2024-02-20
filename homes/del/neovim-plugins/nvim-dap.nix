{plugins, ...}: {
  config = builtins.readFile ./nvim-dap.lua;
  plugin = plugins.nvim-dap;
  type = "lua";
}
