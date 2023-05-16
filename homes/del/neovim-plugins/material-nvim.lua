vim.g.material_style = "lighter"

require('material').setup({
	contrast = {
		cursor_line = true,
		non_current_windows = true,
	},

	plugins = {
		"gitsigns",
		"hop",
		"indent-blankline",
		"nvim-web-devicons",
	},

	styles = {
		comments = { italic = true },
	},
});

vim.cmd.colorscheme('material')
