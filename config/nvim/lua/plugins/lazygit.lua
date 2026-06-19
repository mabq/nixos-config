return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      configure = true, -- automatically configure LazyGit to use the current colorscheme and integrate edit with the current neovim instance.
      win = {
        style = {
          -- make full screen to see more
          height = 0,
          width = 0,
        },
      },
    },
  },
  keys = {
    {
      "<leader>og",
      function()
        Snacks.lazygit.open()
      end,
      desc = "Git",
    },
  },
}
