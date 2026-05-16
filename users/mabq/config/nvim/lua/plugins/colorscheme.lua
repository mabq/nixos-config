--[[

Highlight groups:

  Neovim does NOT directly color keywords, comments, strings or windows,
  instead it colors "highlight groups".

  Colorschemes define colors for many highlight groups.

  Some color schemes just edit the default highlight groups, others also
  add highlight groups to support many popular plugins.

    `:h hi` - learn about highlight groups
    `:hi` - show all currently available highlight groups

  To define you own highlight groups, use:

    vim.api.nvim_set_hl(0, "<group-name>", {
      fg = "#5c6370", -- use a specific color
      link = <highlight group>, -- or use an already defined highlight group
    })

Syntax highlighting:

  Tools like Tree-sitter or LSPs determine what something is. For example, in
  Lua the `local` token is recognized as a keyword.

  Colorschemes decide how it looks. Neovim gets the highlight group assigned
  to the "keyword" highlight group and applies styles accordingly.

    `:Inspect` - shows the highlight group assigned to the token under cursor

Not just syntax:

  UI elements also use highlight groups.

  For example you can use the "WinSeparator" highlight group to edit the styles
  assigned to the window separator characters.

--]]

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

vim.opt.termguicolors = true -- enable 24-bit colors

vim.opt.cursorline = true -- whether to highlight cursor line

vim.opt.laststatus = 3 -- must be set to `3` to display the horizontal split separator character

vim.opt.fillchars.vert = "┆" -- vertial split separator character
vim.opt.fillchars.horiz = "┄" -- horizontal split separator character

--------------------------------------------------------------------------------
-- Edit highlight groups
--------------------------------------------------------------------------------

-- Make the separator character more visible
vim.api.nvim_set_hl(0, "WinSeparator", {
  link = "LineNr", -- use the same highlight group as the line numbers
})

--------------------------------------------------------------------------------
-- Install themes
--------------------------------------------------------------------------------

return {
  -- Default theme:
  --   Only this theme is automatically loaded at startup.
  --   Must be loaded before all other plugins, the highlight groups it sets are
  --   used by some of those plugins.
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- load it first, see https://lazy.folke.io/spec#spec-loading
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },

  -- Alternative themes:
  --   Only loaded when setting `:colorscheme <name>`.
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
}
