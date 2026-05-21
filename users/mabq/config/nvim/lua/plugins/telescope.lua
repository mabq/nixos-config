-- External packages required!
--   make         To build fzf-native
--   ripgrep      Used by live_grep and grep_string pickers, see `:h telescope.defaults.vimgrep_arguments`
--   fd           Used by find_files

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

-- This function shows the dir part of the path dimmed, so that the filename is easier to locate
--   `:h telescope.defaults.path_display`
dimm_path = function(opts, path)
  local dir = vim.fs.dirname(path)

  if dir == "." then -- top level file, no need to apply optional highlights table
    return path
  end

  local highlights = { -- a list of positions and highlight groups to set the highlighting of the returned path string
    {
      { 0, #dir + 1 }, -- start/end highlight position (+1 for the trailing path separator)
      "TelescopeResultsComment" -- highlight group to apply to the range
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
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- much better sorting performance
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local builtin = require "telescope.builtin"
    local actions = require "telescope.actions"
    local utils = require "telescope.utils"

    require("telescope").setup {
      defaults = { -- `:h telescope.setup`
        results_title = "",
        preview = false, -- make room for file paths, use Oil or Yazi for preview
        mappings = {
          i = { ["<C-y>"] = actions.select_default, }, -- follow the convention
          n = { ["<C-y>"] = actions.select_default, }, -- follow the convention
        },
        path_display = dimm_path,
      },

      pickers = {
        live_grep = { -- `:h telescope.builtin.live_grep`
          results_title = "Results",
          prompt_title = "Grep",
          preview = true,
        },
        find_files = {
          prompt_title = "Files",
          hidden = true, -- look for hidden files by default
          find_command = { -- explicit command arguments to fd
            "fd",
            "--type", "f",          -- Find files only
            "--strip-cwd-prefix",   -- Clean up the path prefixes
            "--hidden",             -- Include hidden files (.env, etc.)
            "--exclude", "node_modules", -- Exclude the heavy stuff
            "--exclude", ".git",    -- Exclude git history directories
          },
        },
        -- git_files = {
        --   hidden = true,
        -- },
      },

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
    pcall(require("telescope").load_extension, "fzf") -- see `:h telescope.defaults.file_sorter`
    pcall(require("telescope").load_extension, "ui-select")

    -- Keymaps
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Grep (root)" })
    vim.keymap.set("n", "<leader>s/", function() builtin.live_grep({
      cwd = utils.buffer_dir(), -- `:h telescope.builtin.live_grep`
      prompt_title = "Grep (cwd)", -- `:h telescope.builtin.live_grep`
    }) end, { desc = "Grep (cwd)" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Git Files" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Telescope" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "Options" })
    vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorschemes" })
    vim.keymap.set("n", "<leader>sH", builtin.colorscheme, { desc = "Highlights" })
    vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Autocommands" })
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
