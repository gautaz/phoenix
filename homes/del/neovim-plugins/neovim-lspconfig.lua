vim.lsp.enable('harper_ls')

vim.lsp.enable('hls')

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			runtime = {
				-- Tell the language server which version of Lua is used (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			telemetry = {
				-- Do not send telemetry data containing a randomized but unique identifier
				enable = false,
			},
			workspace = {
				-- avoid libraries suggestions
				-- https://github.com/LuaLS/lua-language-server/wiki/Libraries
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.enable('lua_ls')

vim.lsp.enable('nil_ls')

vim.lsp.enable('ruff')

vim.lsp.config('yamlls', {
	settings = {
		yaml = {
			customTags = {
				-- Custom tags used by AWS CloudFormation
				[1] = "!GetAtt scalar",
				[2] = "!GetAZs mapping",
				[3] = "!ImportValue scalar",
				[4] = "!Ref scalar",
				[5] = "!Select sequence",
				[6] = "!Split sequence",
				[7] = "!Sub scalar",
				[8] = "!Sub sequence",
			},
		},
	},
})
vim.lsp.enable('yamlls')
