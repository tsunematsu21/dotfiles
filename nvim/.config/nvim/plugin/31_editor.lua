local now, later = Config.now, Config.later

-- Restore cursor
now(function()
  require('mini.misc').setup()
  MiniMisc.setup_restore_cursor() ---@diagnostic disable-line: undefined-global
end)

-- Text objects
later(function()
  require('mini.surround').setup()
end)

later(function()
  local gen_ai_spec = require('mini.extra').gen_ai_spec
  require('mini.ai').setup({
    custom_textobjects = {
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
    },
  })
end)

-- Scroll
later(function()
  vim.pack.add({ 'https://github.com/karb94/neoscroll.nvim' })
  require('neoscroll').setup({})
end)

-- Indent guide
later(function()
  vim.pack.add({ 'https://github.com/saghen/blink.indent' })
  require('blink.indent').setup({
    static = {
      char = '▏',
      highlights = { 'BlinkIndent' },
    },
    scope = {
      indend_at_cursor = true,
      char = '▏',
      highlights = { 'BlinkIndentScope' },
    },
  })
end)

-- Quickfix list
later(function()
  vim.pack.add({ 'https://github.com/stevearc/quicker.nvim' })
  require("quicker").setup()
end)

-- Completion
now(function()
  require('mini.completion').setup({})
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'fuzzy', 'popup' }
end)

now(function()
  require('mini.cmdline').setup({})
end)
