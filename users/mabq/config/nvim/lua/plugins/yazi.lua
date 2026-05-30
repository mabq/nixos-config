return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy", -- loads with first keymap
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  opts = {
    -- https://github.com/mikavilpas/yazi.nvim#%EF%B8%8F%EF%B8%8F-advanced-configuration
    floating_window_scaling_factor = 1,
    yazi_floating_window_border = "none",
    keymaps = {
      show_help = "?",
    },
  },
  keys = {
    { mode = { "n", "v" }, "<leader>oe", "<cmd>Yazi<CR>", desc = "Explorer" },
  },
}

--------------------------------------------------------------------------------

--[[

Yazi is awesome for file management.

The only issue with this plugin is that Yazi is opened/closed every time, so it
does not keep state between launches.

For this reason the `Yazi toggle` command is not very useful at the moment, it
only remembers the last directory where Yazi closed, but it does not remember
opened tabs, applied filters, etc.
  https://github.com/mikavilpas/yazi.nvim/issues/862

--]]
