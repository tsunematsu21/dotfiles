local later, now_if_args = Config.later, Config.now_if_args

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-keymaps', { clear = true }),
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP hover')
    map('n', 'gr', vim.lsp.buf.references, 'LSP references')
    map('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
    map({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>lf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format buffer')
  end,
})

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
