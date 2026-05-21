return {
  "folke/twilight.nvim",
  config = function()
    require("twilight").setup {
      context = -1,
      treesitter = true,
    }

    -- Keybinds
    vim.keymap.set("n", "<leader>tt", "<CMD>Twilight<CR>", { desc = "Twilight" })
  end,
}
