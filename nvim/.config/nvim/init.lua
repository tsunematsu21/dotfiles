vim.loader.enable()

-- Define config table to be able to pass data between scripts
_G.Config = {}


-- Define custom autocommand group.
Config.augroup = vim.api.nvim_create_augroup('custom-config', {})

-- Loading helpers used to organize config into fail-safe parts.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
