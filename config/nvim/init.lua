vim.loader.enable()

local augroup = vim.api.nvim_create_augroup("init.lua", { clear = true })

-- Full color
vim.o.termguicolors = true

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Gutter
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

-- Split
vim.o.splitbelow = true
vim.o.splitright = true

-- Mouse mode
vim.o.mouse = "a"

-- Clipboard
vim.o.clipboard = "unnamedplus"

-- Auto read
vim.o.autoread = true
vim.o.swapfile = false

-- Save undo history
vim.o.undofile = true

-- Wrap
vim.o.wrap = true
vim.opt.showbreak = "↪"
vim.o.breakindent = true
vim.opt.whichwrap:append("<,>,[,]")

-- Tab
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- Search
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true

-- Status line
vim.o.laststatus = 3

-- Command line
vim.o.cmdheight = 1
vim.o.showmode = false

-- Preview substitutions live
vim.o.inccommand = "nosplit"

-- Preserve view when using jumplist and remove unloaded buffers
vim.o.jumpoptions = "view,clean"

-- listchars
vim.o.list = true
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}

-- Fold
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldcolumn = "1"
vim.opt.fillchars = {
  eob = " ",
  foldclose = "",
  foldopen = "",
  foldsep = " ",
  foldinner = " ",
}

-- Cursor line
vim.o.cursorline = true
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  callback = function()
    vim.o.cursorline = false
  end,
  desc = "Hide cursor line in Insert mode",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function()
    vim.o.cursorline = true
  end,
  desc = "Restore cursor line after Insert mode",
})

-- Don't autoinsert comments
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
  desc = "Disable New Line Comment",
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  desc = "Briefly highlight yanked text",
})

-- Diagnostics
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
})

-- General keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix list" })

-- Color scheme
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
require("kanagawa").setup({
  transparent = true,
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      Pmenu = { fg = theme.ui.shade0, bg = "none" },
      PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
      PmenuKind = { fg = theme.ui.shade0, bg = "none" },
      PmenuKindSel = { fg = "none", bg = theme.ui.bg_p2 },
      PmenuExtra = { fg = theme.ui.shade0, bg = "none" },
      PmenuExtraSel = { fg = "none", bg = theme.ui.bg_p2 },
      MsgSeparator = { fg = "none", bg = "none" },
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
    }
  end,
})
vim.cmd.colorscheme("kanagawa-dragon")

-- Dim
vim.pack.add({ "https://github.com/tadaa/vimade" })
require("vimade").setup({
  recipe = { "default", { animate = true } },
  fadelevel = 0.6,
})

-- Treesitter
vim.pack.add({ "https://github.com/romus204/tree-sitter-manager.nvim" })
require("tree-sitter-manager").setup({
  auto_install = true,
})

-- LSP
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "astro",
    "vue_ls",
    "lua_ls",
    "ts_ls",
    "yamlls",
    "taplo",
    "nil_ls",
    "typos_lsp",
  },
})

vim.api.nvim_create_autocmd("LspProgress", {
  group = augroup,
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp." .. ev.data.params.token,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
  end,
})

-- Completion
vim.o.autocomplete = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert", "fuzzy", "popup" }
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildoptions = { "exacttext", "fuzzy", "pum", "tagfile" }

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Quickfix list
vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })
require("quicker").setup()

-- Explorer
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  delete_to_trash = true,
})
vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File Explorer" })

-- Fuzzy finder
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })
local fzf = require("fzf-lua")
fzf.setup({
  grep = { hidden = true },
  ui_select = true,
})

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<leader>f?", function() fzf.builtin() end, { desc = "FzfLua builtins" })
vim.keymap.set("n", "<leader><leader>", function() fzf.global() end, { desc = "Find Globals" })
vim.keymap.set("n", "<leader>fb", function() fzf.buffers() end, { desc = "Open buffers" })
vim.keymap.set("n", "<leader>ff", function() fzf.buffers() end, { desc = "Files" })
vim.keymap.set("n", "<leader>fh", function() fzf.oldfiles() end, { desc = "Opened files history" })
vim.keymap.set("n", "<leader>fl", function() fzf.blines() end, { desc = "Current buffer lines" })
vim.keymap.set("n", "<leader>fL", function() fzf.lines() end, { desc = "Open buffers lines" })
vim.keymap.set("n", "<leader>fq", function() fzf.quickfix() end, { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>fc", function() fzf.loclist() end, { desc = "Location list" })
vim.keymap.set("n", "<leader>fg", function() fzf.lgrep_curbuf() end, { desc = "Live Grep (buffer)" })
vim.keymap.set("n", "<leader>fG", function() fzf.live_grep() end, { desc = "Live Grep (workspace)" })

vim.keymap.set("n", "<leader>la", function() fzf.lsp_code_actions() end, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>lr", function() fzf.lsp_references() end, { desc = "Goto References" })
vim.keymap.set("n", "<leader>ld", function() fzf.lsp_definitions() end, { desc = "Goto Definitions" })
vim.keymap.set("n", "<leader>lg", function() fzf.diagnostics_document()
end, { desc = "Diagnostics (buffer)" }) vim.keymap.set("n", "<leader>lG", function() fzf.diagnostics_workspace() end, { desc = "Diagnostics (workspace)" })
-- stylua: ignore end

-- Git signs
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
local gs = require("gitsigns")
gs.setup({
  current_line_blame = true,
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>h]", function() gs.nav_hunk("next") end, { desc = "Next Hunk" })
vim.keymap.set("n", "<leader>h[", function() gs.nav_hunk("prev") end, { desc = "Previous hunk" })
vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, { desc = "Preview hunk (inline)" })
vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
-- stylua: ignore end

-- mini.nvim
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
require("mini.icons").setup({})
MiniIcons.mock_nvim_web_devicons() ---@diagnostic disable-line: undefined-global
require("mini.indentscope").setup({})
require("mini.misc").setup()
MiniMisc.setup_restore_cursor() ---@diagnostic disable-line: undefined-global
require("mini.ai").setup({})
require("mini.operators").setup({})
require("mini.surround").setup({})
require("mini.pairs").setup({})

-- Status line
vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { { "encoding", show_bomb = true } },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
  inactive_sections = {},
})

-- Keymap helper
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
local wk = require("which-key")
wk.setup({
  preset = "helix",
  spec = {
    -- stylua: ignore start
    { "<leader>f", group = "Finder" },
    { "<leader>h", group = "Git Hunk" },
    { "<leader>l", group = "LSP Actions" },
    { "<leader>W", function() wk.show({ keys = "<C-w>", loop = true }) end, desc = "Window menu (hydra)" },
    { "<leader>H", function() wk.show({ keys = "<leader>h", loop = true }) end, desc = "Git Hunk (hydra)" },
    -- stylua: ignore end
  },
})
