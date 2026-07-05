local now, later, now_if_args = Config.now, Config.later, Config.now_if_args

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

        -- https://github.com/rachartier/tiny-cmdline.nvim
        TinyCmdlineBorder = { bg = 'none' },
        TinyCmdlineNormal = { bg = 'none' },
        TinyCmdlineTitle = { bg = 'none' },

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
      lualine_y = { { 'filetype', icon_only = true } },
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

-- ui2
require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      bufwrite = "msg",
      confirm = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "msg",
      progress = "pager",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "msg",
      undo = "msg",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
    cmd = {
      height = 0.5,
    },
    dialog = {
      height = 0.5,
    },
    msg = {
      height = 0.3,
      timeout = 5000,
    },
    pager = {
      height = 0.5,
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "msg",
  callback = function()
    local ui2 = require("vim._core.ui2")
    local win = ui2.wins and ui2.wins.msg
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:NormalFloat,FloatBorder:FloatBorder",
        { scope = "local", win = win }
      )
    end
  end,
})

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")
local orig_set_pos = msgs.set_pos
msgs.set_pos = function(tgt)
  orig_set_pos(tgt)
  if (tgt == "msg" or tgt == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
    pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
      relative = "editor",
      anchor = "NE",
      row = 1,
      col = vim.o.columns - 1,
      border = "rounded",
    })
  end
end
