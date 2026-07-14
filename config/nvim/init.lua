vim.loader.enable()

vim.env.XDG_STATE_HOME = "/tmp"
vim.env.NVIM_LOG_FILE = "/tmp/nvim/log"
vim.opt.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo"

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.filetype.add({
  filename = {
    [".czrc"] = "json",
  },
})

vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

-- Gutter
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

-- Tab
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Search
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.wrap = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cmdheight = 1
vim.o.showtabline = 0
vim.o.laststatus = 3
vim.o.pumborder = "rounded"
vim.o.winborder = "rounded"

vim.o.autoread = true
vim.o.swapfile = false
vim.o.undofile = true

-- listchars
vim.o.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

-- Cursor line
vim.o.cursorline = true

-- General keymap
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-,>", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit nvim/init.lua" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>R", "<cmd>restart<cr>", { desc = "Restart" })
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true })
vim.keymap.set("x", "<C-/>", "gc", { remap = true, silent = true })

local group = vim.api.nvim_create_augroup("custom_autocmd", { clear = true })

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

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    format = function(diag)
      local details = diag.source
      if diag.code ~= nil then
        local code = tostring(diag.code)
        details = details and ("%s: %s"):format(details, code) or code
      end

      return details and ("%s (%s)"):format(diag.message, details) or diag.message
    end,
  },
  float = {
    border = "rounded",
    source = "if_many",
  },
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

-- Define config table to be able to pass data between scripts
_G.Config = {}

-- Loading helpers used to organize config into fail-safe parts.
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
local misc = require("mini.misc")
Config.now = function(f)
  misc.safely("now", f)
end
Config.later = function(f)
  misc.safely("later", f)
end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
