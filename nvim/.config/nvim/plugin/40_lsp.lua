local later, now_if_args = Config.later, Config.now_if_args

later(function()
  -- Useful status updates for LSP.
  vim.pack.add({ 'https://github.com/j-hui/fidget.nvim' })
  require('fidget').setup {}
end)

later(function()
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
    }
  }
  -- for name, server in pairs(servers) do
  --   vim.lsp.config(name, server)
  --   vim.lsp.enable(name)
  -- end
end)

-- Auto Completion
now_if_args(function()
  vim.pack.add({
    'https://github.com/saghen/blink.lib',
    'https://github.com/saghen/blink.cmp',
  })

  local cmp = require('blink.cmp')
  cmp.build():pwait()
  cmp.setup({
    keymap = {
      preset = 'super-tab',
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  })
end)
