local new_autocmd = Config.new_autocmd

require("vim._core.ui2").enable({})

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'

-- Gutter
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

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

-- listchars
vim.o.list = true
vim.opt.listchars = {
  tab = '→ ',
  trail = '·',
  nbsp = '␣',
  extends = '❯',
  precedes = '❮',
}

-- Cursor line
vim.o.cursorline = true
new_autocmd('InsertEnter', nil, function()
  vim.o.cursorline = false
end, 'Disable cursorline')
new_autocmd('InsertLeave', nil, function()
  vim.o.cursorline = true
end, 'Enable cursorline')
