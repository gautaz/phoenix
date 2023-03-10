{pkgs, ...}: let
  languageServers = with pkgs; [
    lua-language-server
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
      vim.g.mapleader = " "
      vim.opt.diffopt:append "vertical"
      vim.opt.mouse = ""
      vim.opt.termguicolors = true
      vim.opt.wildmode = "longest:full,full"
    '';
    plugins = with pkgs.vimPlugins; [
      {
        # minimal status bar
        config = "require('feline').setup{}";
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
        # easy motion
        config = builtins.readFile ./neovim-hop.lua;
        plugin = hop-nvim;
        type = "lua";
      }
      {
        # display indentation
        config = ''
          require('indent_blankline').setup{
            show_current_context = true,
            show_current_context_start = true,
          }
        '';
        plugin = indent-blankline-nvim;
        type = "lua";
      }
      {
        # configuration for language server protocol client
        config = builtins.readFile ./neovim-lspconfig.lua;
        plugin = nvim-lspconfig;
        type = "lua";
      }
      {
        # better syntax highlighting than vim-polyglot when available
        # also needed by indent-blankline-nvim to show current context
        config = ''
          require('nvim-treesitter.configs').setup{
            highlight = {
              enable = true,
            },
          }
        '';
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
      }
      {
        # icons for the feline status bar
        config = "require('nvim-web-devicons').setup{}";
        plugin = nvim-web-devicons;
        type = "lua";
      }
      vim-abolish # enhanced substitute with :S instead of :s
      vim-better-whitespace # highlight trailing whitespace characters
      vim-commentary # comment lines with gc
      vim-eunuch # sugar for the UNIX shell commands (:Move for example)
      vim-fugitive # git integration
      vim-polyglot # language packs collection (also provides vim-sleuth)
      vim-unimpaired # pairs of bracket maps ([q, ]q, ...)
      vim-visual-star-search # use */# in visual mode
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
