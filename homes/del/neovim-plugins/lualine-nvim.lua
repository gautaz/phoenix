local custom_theme = require('lualine.themes.auto')

custom_theme.inactive = {
	c = { bg = '#AAAAAA', fg = '#CCCCCC' },
	x = { bg = '#AAAAAA', fg = '#CCCCCC' },
}

require('lualine').setup{
	extensions = { "fugitive", "fzf", "quickfix" },
	options = {
		theme = custom_theme,
	},
	sections = {
		lualine_b = {'filename'},
		lualine_c = {'branch', 'diff', 'diagnostics'},
	},
}
