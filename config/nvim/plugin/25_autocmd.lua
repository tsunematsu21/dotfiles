local group = vim.api.nvim_create_augroup("25_autocmd", { clear = true })

-- Cursor line
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function()
    vim.o.cursorline = false
  end,
  desc = "Hide cursor line in Insert mode",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function()
    vim.o.cursorline = true
  end,
  desc = "Restore cursor line after Insert mode",
})

-- On yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  desc = "Briefly highlight yanked text",
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map("n", "K", vim.lsp.buf.hover, "LSP hover")
    map("n", "gr", vim.lsp.buf.references, "LSP references")
    map("n", "grf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")
  end,
  desc = "Set buffer-local LSP keymaps on attach",
})
