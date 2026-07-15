local now_if_args = Config.now_if_args

-- Tree-sitter
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

local languages = {
  "nix",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
}

local function is_missing(language)
  local parser = ("parser/%s.*"):format(language)
  return #vim.api.nvim_get_runtime_file(parser, false) == 0
end

local missing = vim.tbl_filter(is_missing, languages)
if #missing > 0 then
  require("nvim-treesitter").install(missing)
end

local filetypes = {}
for _, language in ipairs(languages) do
  vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(language))
end

local group = vim.api.nvim_create_augroup("treesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = filetypes,
  callback = function(event)
    vim.treesitter.start(event.buf)
  end,
  desc = "Start Tree-sitter",
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
