-- External packages required!
--   make         To build fzf-native
--   fd           Explicitly used by the `find_files` picker below
--   ripgrep      Automatically used by `live_grep` and `grep_string` pickers, see `:h telescope.defaults.vimgrep_arguments`

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

-- This function applies a highlight group to the directory section of the path
-- making it much easier to focus eyesight on the filename.
--   `:h telescope.defaults.path_display`
local dimm_path = function(opts, path)
  local dir = vim.fs.dirname(path) -- dir section of the path, returns `.` if the file is at the cwd
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

--------------------------------------------------------------------------------
-- Plugin config
--------------------------------------------------------------------------------

return {
  "nvim-telescope/telescope.nvim",
  version = "*", -- use the latest stable version
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- much faster filtering and ranking as you type!
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local builtin = require "telescope.builtin"
    local actions = require "telescope.actions"
    local utils = require "telescope.utils"

    require("telescope").setup {
      -- Telescope defaults --
      --   `:h telescope.setup`
      defaults = {
        preview = false, -- not needed for most pickers, enabled by picker where needed below
        results_title = "",
        mappings = {
          i = { ["<C-y>"] = actions.select_default, }, -- follow the convention
          n = { ["<C-y>"] = actions.select_default, }, -- follow the convention
        },
        path_display = dimm_path,
      },

      -- Pickers configs --
      pickers = {
        -- `:h telescope.builtin.live_grep`
        live_grep = {
          preview = true, -- required for this one!
          results_title = "Results",
        },
        -- `:h telescope.builtin.find_files`
        find_files = {
          find_command = {
            -- Only used to produce the initial list, filtering and randing is
            -- done by fzf-native.
            -- Telescope uses `rg` if available by default. Here we explicitly
            -- use `fd` to hide the `.git` dir while still showing our dotfiles.
            -- `fd` respects `.gitignore` so it won't show those by default.
            --   https://github.com/nvim-telescope/telescope.nvim/blob/7d324792b7943e4aa16ad007212e6acc6f9fe335/lua/telescope/builtin/__files.lua#L281
            "fd",
            "--type", "f",           -- only files (no dirs, symlinks, etc.)
            "--color", "never",      -- https://github.com/nvim-telescope/telescope.nvim/blob/7d324792b7943e4aa16ad007212e6acc6f9fe335/lua/telescope/builtin/__files.lua#L291
            "--hidden",              -- include dotfiles
            "--strip-cwd-prefix",    -- clean relative paths (no leading ./)
            "--follow",              -- follow symlinks
            "--exclude", ".git",     -- exclude .git explicitly
            -- "--no-ignore",           -- don't respect .gitignore (telescope has its own filtering)
          },
        },
      },

      -- Extensions configs --
      extensions = {
        fzf = {
          -- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
          fuzzy = false, -- most of the time fuzzy matches are just noice, enable exact match by default
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    }

    -- Load extensions
    pcall(require("telescope").load_extension, "fzf") -- fzf-native, verify with `:checkhealth telescope`
    pcall(require("telescope").load_extension, "ui-select")

    -- Keymaps --

    --   find keymaps
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>fF", function() builtin.find_files({
      cwd = utils.buffer_dir(), -- relative to the current buffer
      prompt_title = "Find Files (bufdir)",
    }) end, { desc = "Files (bufdir)" })
    vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git Files" })

    --   search keymaps
    -- vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>/", builtin.resume, { desc = "Resume Telescope" })
    vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>sL", function() builtin.live_grep({
      cwd = utils.buffer_dir(),
      prompt_title = "Live Grep (bufdir)",
    }) end, { desc = "Live Grep (bufdir)" })
    vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Autocommands" })
    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorschemes" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>sH", builtin.highlights, { desc = "Highlight Groups" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "Options" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>ss", builtin.spell_suggest, { desc = "Spell Suggest" })
    vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Telescope Builtins" })
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
