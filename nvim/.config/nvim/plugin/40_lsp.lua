local now_if_args = Config.now_if_args

vim.api.nvim_create_autocmd('LspAttach', {
  group = Config.augroup,
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP hover')
    map('n', 'gr', vim.lsp.buf.references, 'LSP references')
    map('n', 'grf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format buffer')
  end,
  desc = 'LSP keymaps',
})

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
      'taplo',
    }
  }
end)
