{plugins, ...}: {
  config = ''
    require('lualine').setup{
      extensions = { "fugitive", "fzf", "quickfix" },
    }
  '';
  plugin = plugins.lualine-nvim;
  type = "lua";
}
