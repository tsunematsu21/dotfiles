local now, later, now_if_args = Config.now, Config.later, Config.now_if_args

require("vim._core.ui2").enable({})

-- On yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = Config.augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
  desc = 'Highlight on yank',
})

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
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = 'none' -- Remove gutter background
          }
        }
      }
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        Pmenu = { fg = theme.ui.shade0, bg = 'none' },
        PmenuSel = { fg = 'none', bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        PmenuKind = { fg = theme.ui.shade0, bg = 'none' },
        PmenuKindSel = { fg = 'none', bg = theme.ui.bg_p2 },
        PmenuExtra = { fg = theme.ui.shade0, bg = 'none' },
        PmenuExtraSel = { fg = 'none', bg = theme.ui.bg_p2 },
        MsgSeparator = { fg = 'none', bg = 'none' },
        NormalFloat = { bg = 'none' },
        FloatBorder = { bg = 'none' },
        FloatTitle = { bg = 'none' },

       -- https://github.com/saghen/blink.indent
        BlinkIndent = { fg = theme.ui.bg_p1 },
        BlinkIndentScope = { fg = theme.ui.bg_p2 },
      }
    end
  })
  vim.cmd.colorscheme('kanagawa-dragon')
end)

-- Status line
now(function()
  vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
  require('lualine').setup({
    options = {
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      lualine_x = { { 'encoding', show_bomb = true } },
      lualine_y = { 'filetype' },
      lualine_z = { 'location' },
    },
    inactive_sections = {},
  })
end)

-- Dim
later(function()
  vim.pack.add({ 'https://github.com/TaDaa/vimade' })
  require('vimade').setup({
    recipe = { 'default', { animate = true } },
    fadelevel = 0.6,
  })
end)

-- Notification
now(function()
  require('mini.notify').setup({})
end)
