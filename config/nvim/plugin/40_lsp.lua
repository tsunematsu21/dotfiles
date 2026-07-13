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
      'taplo',
      'nil_ls', -- Nix
      'typos_lsp',
    }
  }

  vim.diagnostic.config {
    severity_sort = true,
    virtual_text = {
      format = function(diag)
        local details = diag.source
        if diag.code ~= nil then
          local code = tostring(diag.code)
          details = details and ('%s: %s'):format(details, code) or code
        end

        return details and ('%s (%s)'):format(diag.message, details) or diag.message
      end,
    },
    float = {
      border = 'rounded',
      source = 'if_many',
    },
  }
end)
