return {
  "dmtrKovalenko/fff.nvim",
  opts = {
    debug = {
      enabled = true,
      show_scores = true,
    },
  },
  lazy = false, -- the plugin lazy-initialises itself
  keys = {
    {
      "<leader>ff",
      function()
        require("fff").find_files()
      end,
      desc = "FFFind files",
    },
    {
      "<leader>fg",
      function()
        require("fff").live_grep()
      end,
      desc = "LiFFFe grep",
    },
    {
      "<leader>fz",
      function()
        require("fff").live_grep { grep = { modes = { "fuzzy", "plain" } } }
      end,
      desc = "Live fffuzy grep",
    },
    {
      "<leader>fc",
      function()
        require("fff").live_grep { query = vim.fn.expand "<cword>" }
      end,
      desc = "Search current word",
    },
  },
}
