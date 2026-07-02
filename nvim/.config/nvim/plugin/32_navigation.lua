local now, later = Config.now, Config.later

-- Explorer
now(function()
  vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })

  function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
      return vim.fn.fnamemodify(dir, ":~")
    else
      -- If there is no current directory (e.g. over ssh), just show the buffer name
      return vim.api.nvim_buf_get_name(0)
    end
  end

  require('oil').setup({
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        if name == '.git' then
          return true
        end
      end,
    },
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  })
  vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'File explorer' })
end)

-- Fuzzy finder
later(function()
  vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

  local fzf = require('fzf-lua')
  fzf.setup({
    grep = {
      hidden = true,
    },
    ui_select = true,
  })

  -- Find
  vim.keymap.set('n', '<leader>?', function() fzf.helptags() end, { desc = 'Help page' })
  vim.keymap.set('n', '<leader><leader>', function() fzf.global() end, { desc = 'Find Global' })
  vim.keymap.set('n', '<leader>k', function() fzf.keymaps() end, { desc = 'Keymaps' })
  vim.keymap.set({ 'n', 'v' }, '<leader>f?', function() fzf.builtin() end, { desc = 'FzfLua builtins' })
  vim.keymap.set('n', '<leader>f/', function() fzf.search_history() end, { desc = 'Search History' })
  vim.keymap.set('n', '<leader>f:', function() fzf.command_history() end, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>fx', function() fzf.commands() end, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>ff', function() fzf.files() end, { desc = 'Files' })
  vim.keymap.set('n', '<leader>fr', function() fzf.resume() end, { desc = 'Resume' })
  vim.keymap.set('n', '<leader>fb', function() fzf.buffers() end, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>fh', function() fzf.history({ cwd = vim.uv.cwd() }) end, { desc = 'Oldfiles (cwd)' })
  vim.keymap.set('n', '<leader>fH', function() fzf.history({ include_current_session = true }) end, { desc = 'Oldfiles (All)' })
  vim.keymap.set('n', '<leader>fu', function() fzf.undotree() end, { desc = 'Undotree' })
  vim.keymap.set('n', '<leader>fg', function() fzf.lgrep_curbuf() end, { desc = 'Grep (buf)' })
  vim.keymap.set('n', '<leader>fG', function() fzf.live_grep() end, { desc = 'Grep' })
  vim.keymap.set('n', '<leader>fl', function() fzf.blines() end, { desc = 'Line (buf)' })
  vim.keymap.set('n', '<leader>fL', function() fzf.lines() end, { desc = 'Line' })
  vim.keymap.set({ 'n', 'v' }, '<leader>fw', function() fzf.grep_cword() end, { desc = 'Grep word' })
  vim.keymap.set({ 'n', 'v' }, '<leader>fW', function() fzf.grep_cWORD() end, { desc = 'Grep WORD' })
  vim.keymap.set({ 'n', 'v' }, '<leader>fv', function() fzf.grep_visual() end, { desc = 'Grep Visual selection' })

  -- Git
  vim.keymap.set('n', '<leader>gf', function() fzf.git_files() end, { desc = 'Git Files' })
  vim.keymap.set('n', '<leader>gb', function() fzf.git_branches() end, { desc = 'Git Branches' })
  vim.keymap.set({ 'n', 'v' }, '<leader>gB', function() fzf.git_blame() end, { desc = 'Git Blame' })
  vim.keymap.set({ 'n', 'v' }, '<leader>gc', function() fzf.git_bcommits() end, { desc = 'Git Log (buf)' })
  vim.keymap.set('n', '<leader>gl', function() fzf.git_commits() end, { desc = 'Git Log' })
  vim.keymap.set('n', '<leader>gs', function() fzf.git_status() end, { desc = 'Git Status' })
  vim.keymap.set('n', '<leader>gh', function() fzf.git_hunks() end, { desc = 'Git Diff (hunks)' })
  vim.keymap.set('n', '<leader>gH', function() fzf.git_diff() end, { desc = 'Git Diff' })

  -- LSP
  vim.keymap.set('n', '<leader>la', function() fzf.lsp_code_actions() end, { desc = 'Code Actions' })
  vim.keymap.set('n', '<leader>ll', function() fzf.lsp_finder() end, { desc = 'LSP Finder' })
  vim.keymap.set('n', '<leader>ld', function() fzf.lsp_definitions() end, { desc = 'Goto Definition' })
  vim.keymap.set('n', '<leader>lD', function() fzf.lsp_declarations() end, { desc = 'Goto Declarations' })
  vim.keymap.set('n', '<leader>ls', function() fzf.lsp_document_symbols() end, { desc = 'LSP Symbols (buffer)' })
  vim.keymap.set('n', '<leader>lS', function() fzf.lsp_workspace_symbols() end, { desc = 'LSP Symbols (workspace)' })
  vim.keymap.set('n', '<leader>lg', function() fzf.diagnostics_document() end, { desc = 'Buffer Diagnostics' })
  vim.keymap.set('n', '<leader>lG', function() fzf.diagnostics_workspace() end, { desc = 'Workspace Diagnostics' })
end)
