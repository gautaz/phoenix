{plugins, ...}: {
  config = ''
    require('nvim-treesitter.configs').setup{
      highlight = { enable = true },
    }
  '';
  plugin = plugins.nvim-treesitter.withAllGrammars;
  type = "lua";
}
