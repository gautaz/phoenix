vim.g.opencode_opts = {
  backend = "ollama",
  model = "deepseek-coder-v2",
  -- Minimal opts to avoid snacks warnings
  input = {},
  picker = {},
}

local default_opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "x" }, "<leader>oo", function() require('opencode').prompt("@this") end, default_opts)
vim.keymap.set({ "n", "x" }, "<leader>os", function() require('opencode').select() end, default_opts)
vim.keymap.set("n", "<leader>ot", function() require('opencode').toggle() end, default_opts)
vim.keymap.set("n", "<leader>on", function() require('opencode').command("session_new") end, default_opts)
