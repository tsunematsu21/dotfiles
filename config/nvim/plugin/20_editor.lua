local now, later = Config.now, Config.later

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

  vim.keymap.set("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
  end, { expr = true, desc = "Select next completion item" })

  vim.keymap.set("i", "<S-Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
  end, { expr = true, desc = "Select previous completion item" })

  vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
  end, { expr = true, desc = "Confirm completion item" })
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
