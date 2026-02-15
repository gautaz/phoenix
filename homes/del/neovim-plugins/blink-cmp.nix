{plugins, ...}: {
  config = builtins.readFile ./blink-cmp.lua;
  plugin = plugins.blink-cmp;
  type = "lua";
}
