return {
  -- TODO: Add delta to make diffs easier to read
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>g", "<cmd>LazyGit<CR>", desc = "LazyGit" },
  },
}
