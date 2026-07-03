local now, later, now_if_args, new_autocmd = Config.now, Config.later, Config.now_if_args, Config.new_autocmd

-- On yank
new_autocmd('TextYankPost', nil, function()
  vim.highlight.on_yank({ timeout = 300 })
end, 'Highlight on yank')

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
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
        PmenuSel = { fg = 'none', bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        PmenuKind = { bg = theme.ui.bg_p1 },
        PmenuKindSel = { fg = 'none', bg = theme.ui.bg_p2 },
        PmenuExtra = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
        PmenuExtraSel = { fg = 'none', bg = theme.ui.bg_p2 },
        MsgSeparator = { fg = 'none', bg = 'none' },
        NormalFloat = { bg = 'none' },
        FloatBorder = { bg = 'none' },
        FloatTitle = { bg = 'none' },
        -- https://github.com/rachartier/tiny-cmdline.nvim
        TinyCmdlineBorder = { bg = theme.ui.bg },
        TinyCmdlineNormal = { bg = theme.ui.bg },
        TinyCmdlineTitle = { bg = theme.ui.bg },
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
      lualine_b = { 'branch', 'diff', 'diagnostics'},
      lualine_c = { 'filename' },
      lualine_x = {{ 'encoding', show_bomb = true }},
      lualine_y = {{ 'filetype', icon_only = true }},
      lualine_z = { 'location' },
    },
    inactive_sections = {},
  })
end)

-- Command line
now(function()
  vim.pack.add({ 'https://github.com/rachartier/tiny-cmdline.nvim' })
  vim.o.cmdheight = 0
  require('tiny-cmdline').setup({
    native_types = {},
    title = {
      enabled = true,
    },
  })
end)

-- Scrollbar
now_if_args(function()
  vim.pack.add({ 'https://github.com/petertriho/nvim-scrollbar' })
  require("scrollbar").setup({})
end)
