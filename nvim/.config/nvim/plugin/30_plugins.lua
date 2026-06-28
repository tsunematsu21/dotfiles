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
  require('mini.hues').setup({ background = '#282c34', foreground = '#c0c8cc' })
end)

later(function()
  vim.pack.add({ 'https://github.com/mvllow/modes.nvim' })

  local palette = require('mini.hues').get_palette()
  require('modes').setup({
    colors = {
      copy = palette.yellow,
      delete = palette.red,
      format = palette.orange,
      insert = palette.green,
      replace = palette.azure,
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
    open_mapping = [[<c-t>]],
  })
end)
