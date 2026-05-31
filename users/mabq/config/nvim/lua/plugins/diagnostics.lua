-- Configure Neovim diagnostics
--   `:h vim.diagnostic.Opts`
vim.diagnostic.config {
  virtual_text = true, -- whether to show virtual text at the end of the line
  virtual_lines = false, -- whether to show virtual text in virtual lines

  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  jump = {
    -- Auto open the float so you can easily read the errors when jumping with `[d` and `]d`
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      }
    end,
  },
}

-- Keymaps
vim.keymap.set("", "<leader>tl", function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  else
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end
end, { desc = "Virtual Lines" })

vim.keymap.set('n', '<leader>d', vim.diagnostic.setqflist, { desc = 'Diagnostics' })

--------------------------------------------------------------------------------

return {
  enabled = false,
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  keys = {
    { "<leader>od", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>oD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
    -- { "<leader>ds", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
    -- { "<leader>dS", "<cmd>Trouble lsp toggle<cr>", desc = "Symbols (LSP)" },
    { "<leader>ol", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
    { "<leader>oq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    -- {
    --   "[q",
    --   function()
    --     if require("trouble").is_open() then
    --       require("trouble").prev({ skip_groups = true, jump = true })
    --     else
    --       local ok, err = pcall(vim.cmd.cprev)
    --       if not ok then
    --         vim.notify(err, vim.log.levels.ERROR)
    --       end
    --     end
    --   end,
    --   desc = "Previous Quickfix Item",
    -- },
    -- {
    --   "]q",
    --   function()
    --     if require("trouble").is_open() then
    --       require("trouble").next({ skip_groups = true, jump = true })
    --     else
    --       local ok, err = pcall(vim.cmd.cnext)
    --       if not ok then
    --         vim.notify(err, vim.log.levels.ERROR)
    --       end
    --     end
    --   end,
    --   desc = "Next Trouble/Quickfix Item",
    -- },
  },
}
