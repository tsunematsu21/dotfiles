local now_if_args = Config.now_if_args

-- Tree-sitter
vim.pack.add({
  "https://github.com/romus204/tree-sitter-manager.nvim",
  "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
})

local languages = {
  "astro",
  "vue",
  "typescript",
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

require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  if option == "commentstring" then
    return require("ts_context_commentstring.internal").calculate_commentstring() or get_option(filetype, option)
  end

  return get_option(filetype, option)
end

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
