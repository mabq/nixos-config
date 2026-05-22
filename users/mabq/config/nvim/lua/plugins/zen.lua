return {
  "folke/zen-mode.nvim",
  config = function()
    require("zen-mode").setup {
      window = {
        backdrop = 1,
        height = 0.9,
        width = 0.8,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          list = false,
          cursorline = false,
        },
      },
      plugins = {
        twilight = { enabled = false }, -- whether to enable Twilight when zen mode opens
      },
    }

    -- Keybinds
    vim.keymap.set("n", "<leader>tz", "<CMD>ZenMode<CR>", { desc = "Zen Mode" })
  end,
}
