local later = Config.later

-- General keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-,>', '<cmd>edit $MYVIMRC<cr>', { desc = 'Edit nvim/init.lua'})
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Write' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', '<cmd>quitall<cr>', { desc = 'Quit All' })
vim.keymap.set('n', '<leader>R', '<cmd>restart<cr>', { desc = 'Restart' })

-- Keymap suggest
later(function()
  vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

  require('which-key').setup {
    preset = 'helix',
    delay = 0,
    spec = {
      { '<leader>a', group = 'AI Agent', mode = { 'n', 't', 'i', 'x' } },
      { '<leader>f', group = 'Find', mode = { 'n', 'v' } },
      { '<leader>g', group = 'Git', mode = { 'n', 'v' } },
      { '<leader>h', group = 'Git Hunks', mode = { 'n', 'v' } },
      { '<leader>l', group = 'LSP', mode = { 'n', 'v' } },
      { '<leader>t', group = 'Terminal', mode = { 'n' } },
    },
  }
end)
