{pkgs, ...}: let
  languageServers = with pkgs; [
    lua-language-server
    nil # nix
    omnisharp-roslyn # dotnet
  ];
  plugins = import ./neovim-plugins {inherit pkgs;};
in {
  home.packages = with pkgs;
    [
      dotnet-sdk # needed for omnisharp-roslyn
      gcc # needed by nvim-treesitter
      jq # used by rest-nvim
      html-tidy # used by rest-nvim
      xclip # used by neovim to manage the clipboard
    ]
    ++ languageServers;

  programs.neovim = {
    defaultEditor = true;
    enable = true;

    extraLuaConfig = ''
      vim.g.mapleader = " "
      vim.opt.background = "light";
      vim.opt.diffopt:append "vertical"
      vim.opt.mouse = ""
      vim.opt.termguicolors = true
      vim.opt.wildmode = "longest:full,full"
    '';

    plugins =
      (with plugins; [
        comment-nvim # comment lines with gc
        feline-nvim # minimal status bar
        fzf-lua # fuzzy finder integration
        gitsigns-nvim # git decorations
        hop-nvim # easy motion
        indent-blankline-nvim # display indentation
        nvim-highlight-colors # display colors (#affafa)
        nvim-lspconfig # configuration for language server protocol client
        nvim-treesitter # better syntax highlighting than vim-polyglot when available, also needed by indent-blankline-nvim to show current context
        nvim-web-devicons # icons for the feline status bar
        papercolor-theme # color scheme
        rest-nvim # call REST endpoints from an HTTP file (RFC 2616)
      ])
      ++ (with pkgs.vimPlugins; [
        vim-abolish # enhanced substitute with :S instead of :s
        vim-better-whitespace # highlight trailing whitespace characters
        vim-eunuch # sugar for the UNIX shell commands (:Move for example)
        vim-fugitive # git integration
        vim-markdown-composer # preview markdown files in browser
        vim-polyglot # language packs collection (also provides vim-sleuth)
        vim-unimpaired # pairs of bracket maps ([q, ]q, ...)
        vim-visual-star-search # use */# in visual mode
      ]);

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
