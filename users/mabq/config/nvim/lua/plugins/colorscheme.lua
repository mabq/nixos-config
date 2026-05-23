-- Read notes at the bottom

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------
vim.opt.termguicolors = true -- enable 24-bit colors

vim.opt.cursorline = true -- whether to highlight cursor line

vim.opt.laststatus = 3 -- must be set to `3` to display the horizontal split separator character

vim.opt.fillchars.vert = "┆" -- vertial split separator character
vim.opt.fillchars.horiz = "┄" -- horizontal split separator character

--------------------------------------------------------------------------------
-- Helper function
--------------------------------------------------------------------------------
local set_colorscheme = function(colorscheme)
  return function()
    vim.cmd.colorscheme(colorscheme)

    -- Make the separator character more visible
    -- Must be set after setting the theme to pick the correct highlight group
    vim.api.nvim_set_hl(0, "WinSeparator", {
      link = "LineNr", -- use the same highlight group as the line numbers
    })
  end
end

--------------------------------------------------------------------------------
-- Install themes
--------------------------------------------------------------------------------
return {
  -- Default theme --
  --   Only this theme is automatically loaded at startup.
  --   Must be loaded before all other plugins, the highlight groups it sets are
  --   used by some of those plugins.
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- load it first, see https://lazy.folke.io/spec#spec-loading
    opts = { style = "moon" }, -- https://github.com/folke/tokyonight.nvim#%EF%B8%8F-configuration
    config = set_colorscheme("tokyonight")
  },

  -- Alternative themes --
  --   Only loaded when setting `:colorscheme <name>`.
  --
  --   Catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  }
}

--------------------------------------------------------------------------------

--[[

Highlight groups:

  Colors in Neovim are built around a system called highlight groups.

    `:h hi` - learn about highlight groups
    `:hi` - show all highlight groups currently available
    `:hi <group>` - show styles for the given highlight group
    `:h nvim_set_hl` - how to set highlight groups

    TIP! Use Telescope to search and preview Highlight groups.

  Colorschemes define colors for many highlight groups. Some just edit the
  default Neovim highlight groups. Others also add highlight groups to
  support many popular plugins.


Syntax highlighting:

  Language tools define what a token is. The colorscheme defines how it looks.

    `local` is a keyword in Lua (but not in other languages).
    Keywords are styled with the `Keyword` highlight group.
    The colorscheme defines the styles for the `Keyword` highlight group.
    Neovim displays those colors.

  Neovim can stack highlights from many systems simultaneously, each is
  given a priority, the ones with higher priority win.

    `:Inspect` - shows highlight sources and their priorities

  Normally, the priorities are:

    Syntax highlighting:    very low
    Treesitter:             ~100
    Semantic tokens:        ~125
    Diagnostics:            ~150
    Search highlights:      higher
    Visual selection:       very high
    Cursorline:             special handling

  Note that higher priority layers do NOT necessarily erase lower layers
  completely. For example, one highlight group may provide the foreground
  color, another one the underline, and another one the italic style.

Not just syntax:

  UI elements also use highlight groups.

  For example you can use the "WinSeparator" highlight group to edit the styles
  assigned to the window separator characters.

--]]
