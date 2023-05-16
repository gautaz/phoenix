{plugins, ...}: {
  config = builtins.readFile ./material-nvim.lua;
  plugin = plugins.material-nvim;
  type = "lua";
}
