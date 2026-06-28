-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.o.number = true
vim.o.mouse = 'a'
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = true
vim.o.hlsearch = false
vim.o.signcolumn = 'yes'
vim.o.clipboard = 'unnamedplus'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.cmdheight = 0
vim.o.showtabline = 0
vim.o.showmode = false
vim.o.laststatus = 3
vim.o.list = true
--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = {
  tab = '▸ ',
  trail = '·',
  nbsp = '␣',
  extends = '❯',
  precedes = '❮',
}
