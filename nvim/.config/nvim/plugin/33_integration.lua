local later = Config.now

-- Git signs
later(function()
  vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

  local gs = require('gitsigns')
  gs.setup {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
    },
  }

  vim.keymap.set('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk (inline)' })
  vim.keymap.set('n', '<leader>hP', gs.preview_hunk, { desc = 'Preview hunk (float)' })
  vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
  vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
  vim.keymap.set('v', '<leader>hs', function()
    gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
  end, { desc = 'Stage hunk' })
  vim.keymap.set('v', '<leader>hr', function()
    gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
  end, { desc = 'Reset hunk' })

  -- Scrollbar integration
  require("scrollbar.handlers.gitsigns").setup()
end)

-- Terminal
later(function()
  vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({
    open_mapping = [[<c-.>]],
  })
end)
