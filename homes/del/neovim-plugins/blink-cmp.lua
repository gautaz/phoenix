require('blink.cmp').setup({
  keymap = {
    preset = 'none',
    ['<C-h>'] = { 'cancel', 'show_signature', 'hide_signature' },
    ['<C-j>'] = { 'select_next' },
    ['<C-k>'] = { 'select_prev' },
    ['<C-l>'] = { 'select_and_accept', 'show' },
  },

  cmdline = {
    keymap = {
      preset = 'none',
      ['<C-h>'] = { 'cancel' },
      ['<C-j>'] = { 'select_next' },
      ['<C-k>'] = { 'select_prev' },
      ['<C-l>'] = { 'select_and_accept', 'show' },
    },
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },

  signature = { enabled = true },
})

