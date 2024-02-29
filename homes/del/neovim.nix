{pkgs, ...}: let
  languageServers = with pkgs; [
    lua-language-server
    nil # nix
    omnisharp-roslyn # dotnet
  ];
  completionSourcePlugins = with pkgs.vimPlugins; [
    cmp-nvim-lsp # use language server as a completion source
    cmp-nvim-lsp-signature-help # use language server to also provide function signature
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

    extraLuaConfig = builtins.readFile ./neovim-extra.lua;

    # Search for plugins/schemes: https://neoland.dev
    plugins =
      completionSourcePlugins
      ++ (with plugins; [
        comment-nvim # comment lines with gc
        fidget # Language Server progress bar
        fzf-lua # fuzzy finder integration
        gitsigns-nvim # git decorations
        hop-nvim # easy motion
        indent-blankline-nvim # display indentation
        lualine-nvim # status bar
        material-nvim # color scheme
        nvim-cmp # completion engine
        nvim-highlight-colors # display colors (#affafa)
        nvim-lspconfig # configuration for language server protocol client
        nvim-treesitter # provides syntax highlighting, also needed by indent-blankline-nvim to show current context
        nvim-web-devicons # icons for the feline status bar
      ])
      ++ (with pkgs.vimPlugins; [
        markdown-preview-nvim # preview markdown files in browser
        vim-abolish # enhanced substitute with :S instead of :s
        vim-better-whitespace # highlight trailing whitespace characters
        vim-easy-align # handle character alignment
        vim-eunuch # sugar for the UNIX shell commands (:Move for example)
        vim-fugitive # git integration
        vim-sleuth # heuristically adjusts buffer options (indentation, ...)
        vim-unimpaired # pairs of bracket maps ([q, ]q, ...)
        vim-visual-star-search # use */# in visual mode
      ]);

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
