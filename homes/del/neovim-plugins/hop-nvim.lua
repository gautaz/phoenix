local hop = require('hop')
local hopDirections = require('hop.hint').HintDirection

hop.setup{}

vim.keymap.set("", '<leader>f', function()
	hop.hint_char1({ direction = hopDirections.AFTER_CURSOR })
end, {remap=true})

vim.keymap.set("", '<leader>F', function()
	hop.hint_char1({ direction = hopDirections.BEFORE_CURSOR })
end, {remap=true})

vim.keymap.set("", '<leader>t', function()
	hop.hint_char1({ direction = hopDirections.AFTER_CURSOR, hint_offset = -1 })
end, {remap=true})

vim.keymap.set("", '<leader>T', function()
	hop.hint_char1({ direction = hopDirections.BEFORE_CURSOR, hint_offset = 1 })
end, {remap=true})
