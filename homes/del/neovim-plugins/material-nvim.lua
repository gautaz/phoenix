vim.g.material_style = "lighter"

require('material').setup({
	contrast = {
		cursor_line = true,
		non_current_windows = true,
	},

	high_visibility = {
		lighter = true,
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

	custom_colors = function(colors)
		local colors_editor_bg = "#EEEEEE"
		colors.editor.bg = colors.backgrounds.non_current_windows
		colors.backgrounds.non_current_windows = colors_editor_bg
		colors.backgrounds.cursor_line = colors_editor_bg
	end
});

vim.cmd.colorscheme('material')
