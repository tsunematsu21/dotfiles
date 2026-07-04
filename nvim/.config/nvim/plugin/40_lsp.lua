local new_autocmd, now_if_args = Config.new_autocmd, Config.now_if_args

-- Auto completion
now_if_args(function()
  local callback = function(ev)
    vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert', 'fuzzy', 'popup' }

    -- Diagnostic
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
    })

    -- Keymaps
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('n', 'K', vim.lsp.buf.hover, 'LSP hover')
    map('n', 'gr', vim.lsp.buf.references, 'LSP references')
    map('n', '<leader>lr', vim.lsp.buf.rename, 'Rename symbol')
    map('n', '<leader>lf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format buffer')

    -- Completion
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client or not client:supports_method("textDocument/completion") then
      return
    end

    local chars = {}
    for i = 32, 126 do
      table.insert(chars, string.char(i))
    end
    client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

    vim.keymap.set('i', '<CR>',  'pumvisible() ? "<C-y>" : "<CR>"',  { silent = true, expr = true })
    vim.keymap.set('i', '<C-j>', 'pumvisible() ? "<C-n>" : "<C-j>"', { silent = true, expr = true })
    vim.keymap.set('i', '<C-k>', 'pumvisible() ? "<C-p>" : "<C-k>"', { silent = true, expr = true })
  end

  new_autocmd('LspAttach', nil, callback, 'Enable completion')
end)

-- LSP progress handler
now_if_args(function()
  local callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.client_id,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end

  new_autocmd('LspProgress', nil, callback, 'Show LSP progress')
end)

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
