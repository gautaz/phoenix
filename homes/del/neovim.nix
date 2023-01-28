{pkgs, ...}: {
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      {
        config = ''
          vim.opt.termguicolors = true
          require('feline').setup{}
        '';
        plugin = feline-nvim;
        type = "lua";
      }
      {
        config = "require('gitsigns').setup{}";
        plugin = gitsigns-nvim;
        type = "lua";
      }
      {
        config = "require('nvim-web-devicons').setup{}";
        plugin = nvim-web-devicons;
        type = "lua";
      }
      {
        config = "require('lspconfig').nil_ls.setup{}";
        plugin = nvim-lspconfig;
        type = "lua";
      }
      vim-polyglot
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
