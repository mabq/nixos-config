-- IMPORTANT! External packages required!
--   ripgrep (for live_grep, grep_string)
--   fd (for find_files)

return {
  "nvim-telescope/telescope.nvim",
  version = "*", -- use the latest stable version
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- much better sorting performance
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local builtin = require "telescope.builtin"
    local actions = require "telescope.actions"

    require("telescope").setup {
      defaults = { -- `:h telescope.setup`
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        preview = false, -- disable preview for all pickers by default
        mappings = {
          i = { ["<C-y>"] = actions.select_default, }, -- follow the convention
          n = { ["<C-y>"] = actions.select_default, }, -- follow the convention
        },
      },
      pickers = {
        live_grep = { -- `:h telescope.builtin.live_grep`
          preview = true,
          -- prompt_title = "Search Live",
        },
      },
      extensions = {
        fzf = {
          -- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
          fuzzy = false, -- exact matches by default
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    }

    -- Load extensions
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- Keymaps
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Files" })
    vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Git files" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
    vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Telescope" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
    vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>so", builtin.vim_options, { desc = "Options" })
    vim.keymap.set("n", "<leader>sc", builtin.colorscheme, { desc = "Colorschemes" })
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
