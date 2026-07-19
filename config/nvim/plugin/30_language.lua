local now_if_args = Config.now_if_args

-- Tree-sitter
vim.pack.add({
  "https://github.com/romus204/tree-sitter-manager.nvim",
})

local languages = {
  "astro",
  "vue",
  "nix",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
}

require("tree-sitter-manager").setup({
  assume_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
  },
  ensure_installed = languages,
  highlight = languages,
})

-- Fold
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldcolumn = "1"

vim.opt.fillchars = {
  eob = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
  foldinner = " ",
}

-- LSP
now_if_args(function()
  vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
  })

  require("mason").setup({})

  require("mason-lspconfig").setup({
    automatic_enable = {
      exclude = { "astro" },
    },
    ensure_installed = {
      "astro",
      "vue_ls",
      "lua_ls",
      "ts_ls",
      "yamlls",
      "taplo",
      "nil_ls", -- Nix
      "typos_lsp",
    },
  })

  vim.lsp.enable("astro")
end)
