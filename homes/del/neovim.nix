{pkgs, ...}: let
  languageServers = with pkgs; [
    nil # nix language server
  ];
in {
  home.packages = with pkgs;
    [
      xclip # used by neovim to manage the clipboard
    ]
    ++ languageServers;

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    extraLuaConfig = ''
      vim.o.diffopt = "closeoff,filler,internal,vertical"
      vim.o.mouse = ""
    '';
    plugins = with pkgs.vimPlugins; [
      {
        # minimal status bar
        config = ''
          vim.opt.termguicolors = true
          require('feline').setup{}
        '';
        plugin = feline-nvim;
        type = "lua";
      }
      {
        # git decorations
        config = "require('gitsigns').setup{}";
        plugin = gitsigns-nvim;
        type = "lua";
      }
      {
        # configuration for language server protocol client
        config = "require('lspconfig').nil_ls.setup{}";
        plugin = nvim-lspconfig;
        type = "lua";
      }
      {
        # icons for the feline status bar
        config = "require('nvim-web-devicons').setup{}";
        plugin = nvim-web-devicons;
        type = "lua";
      }
      vim-fugitive # git integration
      vim-polyglot # language packs collection
      vim-visual-star-search # use */# in visual mode
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
