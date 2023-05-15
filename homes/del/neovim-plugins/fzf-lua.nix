{plugins, ...}: {
  config = ''
    require('fzf-lua').setup{}
    vim.keymap.set({ "n" }, "<leader><leader><leader>", ":FzfLua ", default_opts)
    vim.keymap.set({ "n" }, "<leader><leader>b", ":FzfLua buffers\n", default_opts)
    vim.keymap.set({ "n" }, "<leader><leader>f", ":FzfLua files\n", default_opts)
    vim.keymap.set({ "n" }, "<leader><leader>g", ":FzfLua git_files\n", default_opts)
    vim.keymap.set({ "n" }, "<leader><leader>l", ":FzfLua live_grep\n", default_opts)
    vim.keymap.set({ "i" }, "<C-x><C-f>",
    function()
    require("fzf-lua").complete_file({
      winopts = { preview = { hidden = "nohidden" } }
    })
    end,
    { silent = true, desc = "Fuzzy complete file" }
    )
  '';
  plugin = plugins.fzf-lua;
  type = "lua";
}
