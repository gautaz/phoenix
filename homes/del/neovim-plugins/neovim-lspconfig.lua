require('lspconfig').hls.setup {}

require('lspconfig').lua_ls.setup {
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
}

require('lspconfig').nil_ls.setup {}

require('lspconfig').omnisharp.setup {
	cmd = { "@dotnet@", "@omnisharpdll@" },
}

require('lspconfig').yamlls.setup {
	settings = {
		yaml = {
			customTags = {
				-- Custom tags used by AWS CloudFormation
				[1] = "!Ref scalar",
				[2] = "!GetAtt scalar",
			},
		},
	},
}
