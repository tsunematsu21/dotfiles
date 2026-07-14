local now, later = Config.now, Config.later

require("vim._core.ui2").enable({})

-- Keymap suggest
later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = { "n", "x" }, keys = "<Leader>" },

      -- `[` and `]` keys
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },

      -- Built-in completion
      { mode = "i", keys = "<C-x>" },

      -- `g` key
      { mode = { "n", "x" }, keys = "g" },

      -- Marks
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },

      -- Registers
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = { "n", "x" }, keys = "z" },

      -- mini.surround
      { mode = { "n", "x" }, keys = "s" },

      -- text object
      { mode = "x", keys = "i" },
      { mode = "x", keys = "a" },
      { mode = "o", keys = "i" },
      { mode = "o", keys = "a" },
    },

    clues = {
      { mode = { "n", "t", "i", "x" }, keys = "<Leader>;", desc = "+AI Agent" },
      { mode = { "n", "v" }, keys = "<Leader>f", desc = "+Find" },
      { mode = { "n", "v" }, keys = "<Leader>g", desc = "+Git" },
      { mode = { "n", "v" }, keys = "<Leader>h", desc = "+Git Hunk" },
      { mode = { "n", "v" }, keys = "<Leader>l", desc = "+LSP" },

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

-- Icons
now(function()
  require("mini.icons").setup()
  later(function()
    MiniIcons.mock_nvim_web_devicons() ---@diagnostic disable-line: undefined-global
  end)
end)

-- Color
now(function()
  vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
  require("kanagawa").setup({
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none", -- Remove gutter background
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        Pmenu = { fg = theme.ui.shade0, bg = "none" },
        PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        PmenuKind = { fg = theme.ui.shade0, bg = "none" },
        PmenuKindSel = { fg = "none", bg = theme.ui.bg_p2 },
        PmenuExtra = { fg = theme.ui.shade0, bg = "none" },
        PmenuExtraSel = { fg = "none", bg = theme.ui.bg_p2 },
        MsgSeparator = { fg = "none", bg = "none" },
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },

        -- https://github.com/saghen/blink.indent
        BlinkIndent = { fg = theme.ui.bg_p1 },
        BlinkIndentScope = { fg = theme.ui.bg_p2 },
      }
    end,
  })
  vim.cmd.colorscheme("kanagawa-dragon")
end)

-- Indent guide
later(function()
  require("mini.indentscope").setup({})
end)

-- Status line
now(function()
  vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
  require("lualine").setup({
    options = {
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { { "encoding", show_bomb = true } },
      lualine_y = { "filetype" },
      lualine_z = { "location" },
    },
    inactive_sections = {},
  })
end)

-- Dim
later(function()
  vim.pack.add({ "https://github.com/TaDaa/vimade" })
  require("vimade").setup({
    recipe = { "default", { animate = true } },
    fadelevel = 0.6,
  })
end)

-- Notification
now(function()
  require("mini.notify").setup({})
end)
