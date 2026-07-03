local now, later = Config.now, Config.later

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
    open_mapping = [[<c-.>]],
  })
end)

-- AI Agent
later(function()
  vim.pack.add({ 'https://github.com/folke/sidekick.nvim' })
  require('sidekick').setup({
    cli = {
      win = {
        layout = 'right',
      },
    },
  })

  local cli = require('sidekick.cli')
  vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-;>', function() cli.toggle() end, { desc = 'Sidekick Focus' })
  vim.keymap.set('n', '<leader>;a', function() cli.toggle() end, { desc = 'Sidekick Toggle CLI' })
  vim.keymap.set('n', '<leader>;s', function() cli.select() end, { desc = 'Select CLI' })
  vim.keymap.set('n', '<leader>;d', function() cli.close() end, { desc = 'Detach a CLI Session' })
  vim.keymap.set({ 'n', 'x' }, '<leader>;t', function() cli.send({ msg = '{this}' }) end, { desc = 'Send This' })
  vim.keymap.set('n', '<leader>;f', function() cli.send({ msg = '{file}' }) end, { desc = 'Send File' })
  vim.keymap.set('x', '<leader>;v', function() cli.send({ msg = '{selection}' }) end, { desc = 'Send Visual Selection' })
end)

-- Tmux
now(function()
  vim.pack.add({ 'https://github.com/mrjones2014/smart-splits.nvim' })
  require('smart-splits').setup({})

  -- moving between splits
  vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
  vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
  vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
  vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)

  vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
  vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
  vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
  vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
  vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
end)
