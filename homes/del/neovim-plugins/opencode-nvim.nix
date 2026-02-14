{plugins, ...}: {
  config = builtins.readFile ./opencode-nvim.lua;
  plugin = plugins.opencode-nvim;
  type = "lua";
}
