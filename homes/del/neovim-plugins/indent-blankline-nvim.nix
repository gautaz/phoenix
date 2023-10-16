{plugins, ...}: {
  config = ''
    require('ibl').setup{
      show_current_context = true,
      show_current_context_start = true,
    }
  '';
  plugin = plugins.indent-blankline-nvim;
  type = "lua";
}
