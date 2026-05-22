return {
  -- TODO: Add delta to make diffs easier to read
  "kdheepak/lazygit.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ol", "<cmd>LazyGit<CR>", desc = "LazyGit" },
  },
}
