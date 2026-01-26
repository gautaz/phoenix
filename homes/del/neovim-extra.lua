vim.diagnostic.config({
	float = {
		border = "single",
		scope = "cursor",
	},
	severity_sort = true,
})

vim.g.mapleader = " "

vim.opt.cursorline = true
vim.opt.diffopt:append "vertical"
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.wildmode = "longest:full,full"

vim.keymap.set({'n', 'x'}, 'ga', '<Plug>(EasyAlign)')

vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local bufopts = { buffer = args.buf, noremap = true, silent = true }
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
	end,
})
