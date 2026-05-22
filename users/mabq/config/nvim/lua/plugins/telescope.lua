-- External packages required!
--   ripgrep      Required by `live_grep` and `grep_string` pickers to search inside files
--   fd           Required by the `find_files` picker to create the initial list
--   make         Required to build fzf-native

return {
  "nvim-telescope/telescope.nvim",
  version = "*", -- use the latest stable version
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- fzf-native is what filters and ranks the matching results as you type, this plugin really makes a difference
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    -- This function applies a highlight group to dimm the directory section of
    -- the path in all pickers that show files.
    --   `:h telescope.defaults.path_display`
    local dimm_dir = function(opts, path)
      local dir = vim.fs.dirname(path) -- get the path without the filename (returns `.` for files in the cwd)
      local highlights = { -- list of ranges and highlight groups
        {
          {
            0, -- range start
            (dir == ".") and -1 or #dir + 1 -- range end
          },
          "TelescopeResultsComment" -- highlight group to apply
        }
      }
      return path, highlights
    end

    require("telescope").setup {
      -- Telescope defaults (apply to all pickers) --
      --   `:h telescope.setup`
      defaults = {
        preview = false,
        results_title = false,
        mappings = {
          i = { ["<C-y>"] = require("telescope.actions").select_default, }, -- follow the convention
          n = { ["<C-y>"] = require("telescope.actions").select_default, }, -- follow the convention
        },
        path_display = dimm_dir,
      },

      -- Pickers configs --
      pickers = {
        -- `:h telescope.builtin.find_files`
        find_files = {
          prompt_title = "Files",
          find_command = {
            -- If `rg` is available in the system Telescope will use by default.
            --   https://github.com/nvim-telescope/telescope.nvim/blob/7d324792b7943e4aa16ad007212e6acc6f9fe335/lua/telescope/builtin/__files.lua#L281
            --
            -- I prefer `fd` since it is designed specifically for this and I
            -- always have it installed.
            --
            -- These configurations hide all files described in `.gitignore`
            -- (like node_modules) while still showing my own hidden files, like `.gitignore`.
            --
            -- Note that this command is only used to produce the initial list,
            -- the filtering and ranking is performed entirely by fzf-native.
            "fd",
            "--type", "file",        -- include files
            "--type", "symlink",     -- include symlinks
            "--color", "never",      -- telescope does not support colored output, https://github.com/nvim-telescope/telescope.nvim/blob/7d324792b7943e4aa16ad007212e6acc6f9fe335/lua/telescope/builtin/__files.lua#L291
            "--hidden",              -- include my own hidden files
            "--strip-cwd-prefix",    -- clean relative paths (no leading ./)
            "--follow",              -- follow symlinks
            "--exclude", ".git",     -- exclude .git explicitly
            -- "--no-ignore",           -- don't respect .gitignore (telescope has its own filtering)
          },
        },
        -- `:h telescope.builtin.live_grep`
        live_grep = {
          preview = true, -- required for this one!
          results_title = "Results",
        },
        diagnostics = {
          prompt_title = "Diagnostics",
        },
        builtin = {
          prompt_title = "Telescope",
        },
        autocommands = {
          prompt_title = "Autocommands",
        },
        colorscheme = {
          prompt_title = "Colorscheme",
        },
        highlights = {
          prompt_title = "Highlight Groups",
        },
        help = {
          prompt_title = "Help",
        },
        keymaps = {
          prompt_title = "Keymaps",
        },
        vim_options = {
          prompt_title = "Options",
        },
      },

      -- Extensions configs
      extensions = {
        fzf = {
          -- fzf-native configurations
          --   https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
          fuzzy = false, -- most of the time fuzzy matches are just noice
        },
        ["ui-select"] = {
          require('telescope.themes').get_dropdown {},
        },
      },
    }

    -- Load extensions --
    pcall(require("telescope").load_extension, "fzf") -- fzf-native, verify with `:checkhealth telescope`
    pcall(require("telescope").load_extension, "ui-select")


    -- Keymaps --
    local builtin = require "telescope.builtin"

    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>sF", function() builtin.find_files({
      cwd = require("telescope.utils").buffer_dir(),
      prompt_title = "Files (bufdir)",
    }) end, { desc = "Files (bufdir)" })

    vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Git Files" })
    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>sL", function() builtin.live_grep({
      cwd = require("telescope.utils").buffer_dir(),
      prompt_title = "Live Grep (bufdir)",
    }) end, { desc = "Live Grep (bufdir)" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>ss", builtin.spell_suggest, { desc = "Spelling Suggestions" })
    vim.keymap.set("n", "<leader>sa", builtin.builtin, { desc = "Telescope (all)" })
    -- sh: search harpoon
    -- st: search todo

    vim.keymap.set("n", "<leader>sna", builtin.autocommands, { desc = "Autocommands" })
    vim.keymap.set("n", "<leader>sng", builtin.highlights, { desc = "Highlight Groups" })
    vim.keymap.set("n", "<leader>snh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>snk", builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>snc", builtin.colorscheme, { desc = "Colorscheme" })
    vim.keymap.set('n', '<leader>sn.', function() builtin.find_files {
      cwd = vim.fn.stdpath 'config',
      prompt_title = "Config Files (Neovim)",
    } end, { desc = 'Config Files' })
    vim.keymap.set("n", "<leader>sno", builtin.vim_options, { desc = "Options" })

    -- -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
    -- vim.api.nvim_create_autocmd('LspAttach', {
    --   group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }), -- clear to avoid duplication
    --   callback = function(event)
    --     local buf = event.buf
    --
    --     -- We use the same keymaps used by Neovim by default, see `:h lsp-defaults`.
    --     --
    --     -- These are LSP actions are related with pickers, which is why Telescope is useful,
    --     -- once you find what you want you can send the results to Quickfix with `<C-q>`.
    --
    --     -- Find references for the word under your cursor.
    --     vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = 'Goto References' })
    --
    --     -- Jump to the implementation of the word under your cursor.
    --     -- Useful when your language has ways of declaring types without an actual implementation.
    --     vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
    --
    --     -- Jump to the definition of the word under your cursor.
    --     -- This is where a variable was first declared, or where a function is defined, etc.
    --     -- To jump back, press <C-t>.
    --     vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = 'Goto Definition' })
    --
    --     -- Fuzzy find all the symbols in your current document.
    --     -- Symbols are things like variables, functions, types, etc.
    --     vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    --
    --     -- Fuzzy find all the symbols in your current workspace.
    --     -- Similar to document symbols, except searches over your entire project.
    --     vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    --
    --     -- Jump to the type of the word under your cursor.
    --     -- Useful when you're not sure what type a variable is and you want to see
    --     -- the definition of its *type*, not where it was *defined*.
    --     vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    --   end,
    -- })

  end
}

--------------------------------------------------------------------------------

--[[

Help:
  `:checkhealth telescope`
  `:h telescope.setup()`
  `:h telescope.builtin`
  `:h telescope.default.mappings`
   <c-/> in Telescope insert mode
   ? in Telescope normal mode

Learn how to customize pickers:
   `:h telescope.builtin[.<picker-name>]`.
   E.g. `grep_string` is customized to use regex by default, see [Rust regex syntax](https://docs.rs/regex/1.11.1/regex/#syntax).

Learn about fzf syntax:
   https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim.

 NOTE: Trouble integration can be really useful.
 E.g. Use `grep_string` of `live_grep` to obtain a list of files with some specific text in them, refine the list with fzf, then maybe even mark only specific files with <Tab> and then export the list to Trouble.

--]]
