local now, later = Config.now, Config.later

-- Highlight todo, notes, etc in comments
later(function()
  vim.pack.add({ 'https://github.com/folke/todo-comments.nvim' })
  require('todo-comments').setup { signs = false }
end)

-- Icons
now(function()
  require('mini.icons').setup()
  later(function()
    MiniIcons.mock_nvim_web_devicons() ---@diagnostic disable-line: undefined-global
  end)
end)

-- Color
now(function()
  require('mini.hues').setup({ background = '#282c34', foreground = '#dedede' })
end)

-- Mode
later(function()
  local palette = require('mini.hues').get_palette()

  vim.pack.add({ 'https://github.com/mvllow/modes.nvim' })
  require('modes').setup({
    colors = {
      bg = palette.bg,
      copy = palette.yellow,
      delete = palette.red,
      change = palette.red,
      format = palette.orange,
      insert = palette.green,
      replace = palette.blue,
      select = palette.purple,
      visual = palette.purple,
    },
  })
end)

-- Status line
now(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup({})
end)

-- Command / Message
now(function()
  vim.pack.add({
    'https://github.com/MunifTanjim/nui.nvim.git',
    'https://github.com/rcarriga/nvim-notify',
    'https://github.com/folke/noice.nvim',
  })
  require("noice").setup({})
end)

-- Scroll
later(function()
  vim.pack.add({ 'https://github.com/karb94/neoscroll.nvim' })
  require('neoscroll').setup({})
end)

-- Diagnostic
later(function()
  vim.pack.add({ 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' })
  require("tiny-inline-diagnostic").setup({
    options = {
      multilines = {
        enable = true,
      },
    },
  })
end)

-- Terminal
later(function()
  vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })
  require('toggleterm').setup({
    open_mapping = [[<c-j>]],
    shade_terminals = false,
  })
end)

-- AI Agent
later(function()
  vim.pack.add({ 'https://github.com/folke/sidekick.nvim' })
  require('sidekick').setup({})

  local cli = require('sidekick.cli')
  vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function() cli.focus() end, { desc = 'Sidekick Focus' })
  vim.keymap.set('n', '<leader>aa', function() cli.toggle() end, { desc = 'Sidekick Toggle CLI' })
  vim.keymap.set('n', '<leader>as', function() cli.select() end, { desc = 'Select CLI' })
end)
