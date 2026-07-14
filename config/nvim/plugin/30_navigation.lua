local now, later = Config.now, Config.later

-- Restore cursor
now(function()
  require("mini.misc").setup()
  MiniMisc.setup_restore_cursor() ---@diagnostic disable-line: undefined-global
end)

-- Quickfix list
later(function()
  vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })
  require("quicker").setup()
end)

-- Explorer
now(function()
  vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

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

  -- helper function to parse output
  local function parse_output(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
      for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
        -- Remove trailing slash
        line = line:gsub("/$", "")
        ret[line] = true
      end
    end
    return ret
  end

  -- build git status cache
  local function new_git_status()
    return setmetatable({}, {
      __index = function(self, key)
        local ignore_proc = vim.system(
          { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
          {
            cwd = key,
            text = true,
          }
        )
        local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
          cwd = key,
          text = true,
        })
        local ret = {
          ignored = parse_output(ignore_proc),
          tracked = parse_output(tracked_proc),
        }

        rawset(self, key, ret)
        return ret
      end,
    })
  end
  local git_status = new_git_status()

  -- Clear git status cache on refresh
  local refresh = require("oil.actions").refresh
  local orig_refresh = refresh.callback
  refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
  end

  require("oil").setup({
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        local dir = require("oil").get_current_dir(bufnr)
        local is_dotfile = vim.startswith(name, ".") and name ~= ".."
        -- if no local directory (e.g. for ssh connections), just hide dotfiles
        if not dir then
          return is_dotfile
        end
        -- dotfiles are considered hidden unless tracked
        if is_dotfile then
          return not git_status[dir].tracked[name]
        else
          -- Check if file is gitignored
          return git_status[dir].ignored[name]
        end
      end,
    },
    win_options = {
      winbar = "%!v:lua.get_oil_winbar()",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  })
  vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })
end)

-- Fuzzy finder
later(function()
  vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

  local fzf = require("fzf-lua")
  fzf.setup({
    grep = {
      hidden = true,
    },
    ui_select = true,
  })

  local function map_all(mappings)
    for _, mapping in ipairs(mappings) do
      local lhs, picker, desc = unpack(mapping)
      vim.keymap.set(mapping.mode or "n", "<leader>" .. lhs, function()
        local opts = type(mapping.opts) == "function" and mapping.opts() or mapping.opts
        fzf[picker](opts)
      end, { desc = desc })
    end
  end

  map_all({
    { "<leader>", "global", "Find Global" },
  })

  -- Find
  map_all({
    { "?", "helptags", "Help page" },
    { "k", "keymaps", "Keymaps" },
    { "f?", "builtin", "FzfLua builtins", mode = { "n", "v" } },
    { "f/", "search_history", "Search History" },
    { "f:", "command_history", "Command History" },
    { "fx", "commands", "Commands" },
    { "ff", "files", "Files" },
    { "fr", "resume", "Resume" },
    { "fb", "buffers", "Buffers" },
    {
      "fh",
      "history",
      "Oldfiles (cwd)",
      opts = function()
        return { cwd = vim.uv.cwd() }
      end,
    },
    { "fH", "history", "Oldfiles (All)", opts = { include_current_session = true } },
    { "fu", "undotree", "Undotree" },
    { "fg", "lgrep_curbuf", "Grep (buf)" },
    { "fG", "live_grep", "Grep" },
    { "fl", "blines", "Line (buf)" },
    { "fL", "lines", "Line" },
    { "fw", "grep_cword", "Grep word", mode = { "n", "v" } },
    { "fW", "grep_cWORD", "Grep WORD", mode = { "n", "v" } },
    { "fv", "grep_visual", "Grep Visual selection", mode = { "n", "v" } },
  })

  -- Git
  map_all({
    { "gf", "git_files", "Git Files" },
    { "gb", "git_branches", "Git Branches" },
    { "gB", "git_blame", "Git Blame", mode = { "n", "v" } },
    { "gc", "git_bcommits", "Git Log (buf)", mode = { "n", "v" } },
    { "gl", "git_commits", "Git Log" },
    { "gs", "git_status", "Git Status" },
    { "gh", "git_hunks", "Git Diff (hunks)" },
    { "gH", "git_diff", "Git Diff" },
  })

  -- LSP
  map_all({
    { "la", "lsp_code_actions", "Code Actions" },
    { "ll", "lsp_finder", "LSP Finder" },
    { "lr", "lsp_references", "Goto Reference" },
    { "ld", "lsp_definitions", "Goto Definition" },
    { "ls", "lsp_document_symbols", "LSP Symbols (buffer)" },
    { "lS", "lsp_workspace_symbols", "LSP Symbols (workspace)" },
    { "lg", "diagnostics_document", "Buffer Diagnostics" },
    { "lG", "diagnostics_workspace", "Workspace Diagnostics" },
  })
end)
