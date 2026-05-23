local ocv_cmd = "@bash@ -c 'exec -a opencode @ocv@ --port'"

vim.g.opencode_opts = {
  server = {
    start = function()
      require("opencode.terminal").open(ocv_cmd)
    end,
    toggle = function()
      require("opencode.terminal").toggle(ocv_cmd)
    end,
  },
}

local default_opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require('opencode').ask() end, default_opts)
vim.keymap.set({ "n", "x" }, "<leader>oo", function() require('opencode').ask("@this: ") end, default_opts)
vim.keymap.set({ "n", "x" }, "<leader>os", function() require('opencode').select() end, default_opts)
vim.keymap.set("n", "<leader>ot", function() require('opencode').toggle() end, default_opts)
vim.keymap.set("n", "<leader>on", function() require('opencode').command("session_new") end, default_opts)
