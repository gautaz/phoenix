{pkgs, ...}: {
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      {
        config = "require'lspconfig'.nil_ls.setup{}";
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
