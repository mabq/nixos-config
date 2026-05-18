return {
  "https://github.com/lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function() -- function provided by the plugin
      local gitsigns = require "gitsigns"
      vim.keymap.set("n", "<leader>gs", gitsigns.toggle_signs, { desc = "Toggle gitsigns blame" })
    end,
  },
}

--[[

See plugin default configs:
  https://github.com/lewis6991/gitsigns.nvim#-keymaps

To see all available actions, type `:Gitsigns <Tab>`

Close the blame window with `q`, see the autocmds file.

--]]
