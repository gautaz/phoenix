{plugins, ...}: {
  # HTTP filetype switch currently fails due to the following issue:
  # https://github.com/NixOS/nixpkgs/issues/230649
  config = ''
    require('rest-nvim').setup{}
    vim.keymap.set({ "n" }, "<leader>r", "<Plug>RestNvim", default_opts)
    vim.filetype.add({ extension = { http = "http" } })
  '';
  plugin = plugins.rest-nvim;
  type = "lua";
}
