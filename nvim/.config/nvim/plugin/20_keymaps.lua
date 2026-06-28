local later = Config.later

-- General keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-,>', '<cmd>edit $MYVIMRC<cr>', { desc = 'Edit nvim/init.lua'})
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Write' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>Q', '<cmd>quitall<cr>', { desc = 'Quit All' })
vim.keymap.set('n', '<leader>R', '<cmd>restart<cr>', { desc = 'Restart' })

local function open_cfile()
  local target = vim.fn.expand('<cfile>')
  if target == '' then
    return
  end

  if target:match('^%a[%w+.-]*://') and not target:match('^file://') then
    vim.ui.open(target)
    return
  end

  local file, line, col = target, nil, nil
  file, line, col = target:match('^(.+):(%d+):(%d+)$')
  if not file then
    file, line = target:match('^(.+):(%d+)$')
  end
  file = file or target

  if file:match('^file://') then
    file = vim.uri_to_fname(file)
  end

  if vim.bo.buftype == 'terminal' then
    local terminal_win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd('p')
    if vim.api.nvim_get_current_win() == terminal_win or vim.bo.buftype == 'terminal' then
      vim.api.nvim_set_current_win(terminal_win)
      vim.cmd.split()
    end
  end

  vim.cmd.edit(vim.fn.fnameescape(file))
  if line then
    vim.api.nvim_win_set_cursor(0, { tonumber(line), math.max((tonumber(col) or 1) - 1, 0) })
  end
end

vim.keymap.set('n', 'gx', open_cfile, { desc = 'Open file under cursor' })

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
    },
  }
end)
