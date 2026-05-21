return {
  "https://github.com/lewis6991/gitsigns.nvim",
  opts = {
    -- https://github.com/lewis6991/gitsigns.nvim#%EF%B8%8F-installation--usage
    current_line_blame_opts = {
      delay = 250, -- decrease delay time (default 1000)
    },
    on_attach = function() -- function provided by the plugin
      local gitsigns = require "gitsigns"
      vim.keymap.set("n", "<leader>gs", gitsigns.toggle_signs, { desc = "Toggle gitsigns" })
      vim.keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle line blame" })
      vim.keymap.set("n", "<leader>gh", gitsigns.toggle_linehl, { desc = "Toggle line highlight" })
    end,
  },
}

--[[

See plugin default configs:
  https://github.com/lewis6991/gitsigns.nvim#-keymaps

To see all available actions, type `:Gitsigns <Tab>`

Close the blame window with `q`, see the autocmds file.

--]]
