-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({
  filename = {
    [".czrc"] = "json",
  },
})

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
vim.o.pumborder = 'rounded'
vim.o.winborder = 'rounded'

vim.o.autoread = true
vim.o.swapfile = false

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
vim.api.nvim_create_autocmd('InsertEnter', {
  group = Config.augroup,
  callback = function()
    vim.o.cursorline = false
  end,
  desc = 'Disable cursorline',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = Config.augroup,
  callback = function()
    vim.o.cursorline = true
  end,
  desc = 'Enable cursorline',
})
