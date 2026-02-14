require('hlchunk').setup({
    blank = {
        enable = false,
    },
    chunk = {
        enable = true,
        use_treesitter = true,
    },
    indent = {
        chars = {
            " ",
        },
        enable = true,
        use_treesitter = true,
    },
    line_num = {
        enable = true,
        use_treesitter = true,
    },
})
