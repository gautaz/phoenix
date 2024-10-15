{plugins, ...}: {
  config = builtins.readFile ./fzf-lua.lua;
  plugin = plugins.fzf-lua;
  type = "lua";
}
