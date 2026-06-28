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
  vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
  require('kanagawa').setup({
    theme = 'dragon',
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    statementStyle = { bold = false },
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = 'none' -- Remove gutter background
          }
        }
      }
    },
  })
  vim.cmd.colorscheme('kanagawa')
end)

later(function()
  require('mini.indentscope').setup({})

  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = '*',
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end)

-- Mode
later(function()
  local palette = require('kanagawa.colors').setup().palette

  vim.pack.add({ 'https://github.com/mvllow/modes.nvim' })
  require('modes').setup({
    colors = {
      copy = palette.autumnYellow,
      delete = palette.autumnRed,
      change = palette.autumnRed,
      format = palette.surimiOrange,
      insert = palette.springGreen,
      replace = palette.crystalBlue,
      select = palette.oniViolet,
      visual = palette.oniViolet,
    },
    line_opacity = 0.2 ,
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
