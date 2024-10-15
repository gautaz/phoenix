require('fzf-lua').setup{}

vim.keymap.set({ "n" }, "<leader><leader><leader>", ":FzfLua ", default_opts)
vim.keymap.set({ "n" }, "<leader><leader>b", ":FzfLua buffers\n", default_opts)
vim.keymap.set({ "n" }, "<leader><leader>f", ":FzfLua files\n", default_opts)
vim.keymap.set({ "n" }, "<leader><leader>g", ":FzfLua git_files\n", default_opts)

vim.keymap.set(
    { "n" },
    "<leader><leader>l",
    function()
         require'fzf-lua'.live_grep({
            cmd = (os.execute("git rev-parse --is-inside-work-tree") == 0)
                and "git grep --line-number --column --color=always"
                or "grep --binary-files=without-match --line-number --recursive --color=always --perl-regexp -e"
        })
    end,
    default_opts
)

vim.keymap.set(
    { "i" },
    "<C-x><C-f>",
    function()
        require("fzf-lua").complete_file({
            winopts = { preview = { hidden = "nohidden" } }
        })
    end,
    { silent = true, desc = "Fuzzy complete file" }
)
