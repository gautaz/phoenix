local cmp = require('cmp')

cmp.setup({
	mapping = {
		["<C-h>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.abort()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-j>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-k>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-l>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.confirm({ select = true })
			else
				cmp.complete()
			end
		end, { 'i', 's' }),
	},

	snippet = {
		expand = function() end,
	},

	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
	})
})

cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp_document_symbol' }
	}, {
		{ name = 'buffer' }
	})
})
