local now, later = Config.now, Config.later
local now_if_args = Config.now_if_args

-- Text objects
later(function()
  require("mini.surround").setup()
end)

later(function()
  local gen_ai_spec = require("mini.extra").gen_ai_spec
  require("mini.ai").setup({
    custom_textobjects = {
      B = gen_ai_spec.buffer(),
      D = gen_ai_spec.diagnostic(),
      I = gen_ai_spec.indent(),
      L = gen_ai_spec.line(),
      N = gen_ai_spec.number(),
    },
  })
end)

-- Completion
now(function()
  require("mini.completion").setup({})
  vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "fuzzy", "popup" }
end)

-- Command line
now(function()
  require("mini.cmdline").setup({})
end)

-- Git signs
later(function()
  vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

  local gs = require("gitsigns")
  gs.setup({
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
    },
  })

  vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Preview hunk (inline)" })
  vim.keymap.set("n", "<leader>hP", gs.preview_hunk, { desc = "Preview hunk (float)" })
  vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
  vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
  vim.keymap.set("v", "<leader>hs", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Stage hunk" })
  vim.keymap.set("v", "<leader>hr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, { desc = "Reset hunk" })
end)

-- LSP
now_if_args(function()
  vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
  })

  require("mason").setup({})

  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "yamlls",
      "taplo",
      "nil_ls", -- Nix
      "typos_lsp",
    },
  })
end)
