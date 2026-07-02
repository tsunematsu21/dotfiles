local later = Config.later

-- General keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
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
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = { 'n', 'x' }, keys = '<Leader>' },

      -- `[` and `]` keys
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = { 'n', 'x' }, keys = 'g' },

      -- Marks
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },

      -- Registers
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = { 'n', 'x' }, keys = 'z' },

      -- mini.surround
      { mode = { 'n', 'x' }, keys = 's' },

      -- text object
      { mode = 'x', keys = 'i' },
      { mode = 'x', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'o', keys = 'a' },
    },

    clues = {
      { mode = { 'n', 't', 'i', 'x' }, keys = '<Leader>.', desc = '+AI Agent' },
      { mode = { 'n', 'v' }, keys = '<Leader>f', desc = '+Find' },
      { mode = { 'n', 'v' }, keys = '<Leader>g', desc = '+Git' },
      { mode = { 'n', 'v' }, keys = '<Leader>h', desc = '+Git Hunk' },
      { mode = { 'n', 'v' }, keys = '<Leader>l', desc = '+LSP' },

      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      delay = 0,
    },
  })
end)
