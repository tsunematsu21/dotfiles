local now_if_args = Config.now_if_args

-- LSP settings
now_if_args(function()
  vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
  })

  require('mason').setup({})

  require('mason-lspconfig').setup {
    ensure_installed = {
      'lua_ls',
      'ts_ls',
      'yamlls',
    }
  }
end)
