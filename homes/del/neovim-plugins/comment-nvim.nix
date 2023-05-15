{plugins, ...}: {
  config = "require('Comment').setup{}";
  plugin = plugins.comment-nvim;
  type = "lua";
}
