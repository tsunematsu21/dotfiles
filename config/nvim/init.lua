vim.env.XDG_STATE_HOME = '/tmp'
vim.env.NVIM_LOG_FILE = '/tmp/nvim/log'
vim.opt.undodir = vim.env.XDG_STATE_HOME .. '/nvim/undo'

vim.loader.enable()

-- Define config table to be able to pass data between scripts
_G.Config = {}

-- Loading helpers used to organize config into fail-safe parts.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
