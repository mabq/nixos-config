return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "moon" }, -- https://github.com/folke/tokyonight.nvim#%EF%B8%8F-configuration
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "tokyonight-night",
  --   },
  -- },
}
