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
          prompt_title = "Search Files",
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
          prompt_title = "Search Grep",
          preview = true, -- required for this one!
          results_title = "Results",
        },
        colorscheme = {
          prompt_title = "Set Colorscheme",
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

    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })

    vim.keymap.set("n", "<leader>s.", builtin.git_files, { desc = "Git Files" })

    vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Search Grep" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
    vim.keymap.set("n", "<leader>sG", function() builtin.live_grep({
      cwd = require("telescope.utils").buffer_dir(),
      prompt_title = "Search Grep (bufdir)",
    }) end, { desc = "Grep (bufdir)" })

    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Autocommands" })
    vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorscheme" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Highlights" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Key Maps" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume Last Search" }) -- its better to send the results to the quickfix list with <C-q>
    vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "Options" })
    vim.keymap.set("n", "<leader>ss", builtin.spell_suggest, { desc = "Spell Suggest" })
    vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Telescope" })
  end,
}

--------------------------------------------------------------------------------

--[[

felp:
  `:checkhealth telescope`
  `:h telescope.setup()`
  `:h telescope.builtin`
  `:h telescope.default.mappings`

Learn how to customize pickers:
   `:h telescope.builtin[.<picker-name>]`.
   E.g. `grep_string` is customized to use regex by default, see [Rust regex syntax](https://docs.rs/regex/1.11.1/regex/#syntax).

Learn about fzf syntax:
   https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim.

 NOTE: Trouble integration can be really useful.
 E.g. Use `grep_string` of `live_grep` to obtain a list of files with some specific text in them, refine the list with fzf, then maybe even mark only specific files with <Tab> and then export the list to Trouble.

--]]
