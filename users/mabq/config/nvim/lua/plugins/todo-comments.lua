return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("todo-comments").setup {
      signs = false, -- do not show icons in the signs column
      highlight = {
        multiline = false, -- only highlight that line, not the subsequent lines
      },
    }

    -- Keymaps
    vim.keymap.set("n", "<leader>st", "<CMD>TodoTelescope<CR>", { desc = "Todo marks" }) -- from here you can send results to quickfix list
  end
}

--[[

Use the following key words followed by a `:` to mark a section of code with that meaning:

  Key word      Meaning
  --------      ---------------
  PERF          Fully optimized
  HACK          Funky stuff
  TODO          What else?
  NOTE          Leave a note
  FIX           Needs fixing
  WARNING       Why

--]]
