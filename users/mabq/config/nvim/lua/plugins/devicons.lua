-- IMPORTANT: A nerd-font is required

return {
  "nvim-tree/nvim-web-devicons",
  opts = true,
}

--[[

A Nerd Font gives your terminal the ability to render icon characters.

This plugin tells Neovim:

  Which icon belongs to each filetype, e.g. `.js`
  Which color to use for each icon.
  Which highlight group to use.
  What to display for folders vs symlinks vs gitignored files

Then other plugins (like the following) can ask "What icon/color should I show for this file?"

  nvim-tree.lua
  telescope.nvim
  lualine.nvim

--]]
