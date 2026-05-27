require('fzf-lua').setup{}

vim.keymap.set({ "n" }, "<leader><leader><leader>", ":FzfLua ", { silent = true })
vim.keymap.set({ "n" }, "<leader><leader>b", ":FzfLua buffers\n", { silent = true })
vim.keymap.set({ "n" }, "<leader><leader>f", ":FzfLua files\n", { silent = true })
vim.keymap.set({ "n" }, "<leader><leader>g", ":FzfLua git_files\n", { silent = true })

vim.keymap.set(
    { "n" },
    "<leader><leader>l",
    function()
         require'fzf-lua'.live_grep({
            cmd = (os.execute("git rev-parse --is-inside-work-tree") == 0)
                and "git grep --line-number --column --color=always"
                or "grep --binary-files=without-match --line-number --recursive --color=always --perl-regexp -e"
        })
    end
)

vim.keymap.set(
    { "i" },
    "<C-x><C-f>",
    function()
        require("fzf-lua").complete_file({
            winopts = { preview = { hidden = "nohidden" } }
        })
    end,
    { desc = "Fuzzy complete file" }
)
