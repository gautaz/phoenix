require("catppuccin").setup({
    show_end_of_buffer = true,
    color_overrides = {
        latte = {
            base = "#ffffff",
            mantle = "#eeeeee",
        },
    },
    dim_inactive = {
        enabled = true,
    },
    default_integrations = false,
    auto_integrations = false,
    integrations = {
        cmp = true,
        fidget = true,
        fzf = true,
        gitsigns = true,
        hop = true,
        render_markdown = true,
    },
})

vim.cmd.colorscheme "catppuccin"
