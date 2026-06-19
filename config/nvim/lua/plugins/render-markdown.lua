return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  keys = {
    {
      "<leader>tm",
      mode = { "n", "x" },
      function()
        vim.cmd "RenderMarkdown toggle"
      end,
      desc = "Markdown render",
    },
  },
}
