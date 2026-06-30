local later = Config.later

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

-- LazyGit
later(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/kdheepak/lazygit.nvim',
  })

  vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'Open LazyGit' })
end)

-- Terminal
later(function()
  vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({
    open_mapping = [[<c-t>]],
  })
end)

-- AI Agent
later(function()
  vim.pack.add({ 'https://github.com/folke/sidekick.nvim' })
  require('sidekick').setup({
    cli = {
      win = {
        layout = 'left',
      },
    },
  })

  local cli = require('sidekick.cli')
  vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function() cli.focus() end, { desc = 'Sidekick Focus' })
  vim.keymap.set('n', '<leader>aa', function() cli.toggle() end, { desc = 'Sidekick Toggle CLI' })
  vim.keymap.set('n', '<leader>as', function() cli.select() end, { desc = 'Select CLI' })
end)
