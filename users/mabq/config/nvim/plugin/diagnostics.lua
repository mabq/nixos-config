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
vim.keymap.set("", "<leader>td", function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  else
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end
end, { desc = "Diagnostic Lines" })

vim.keymap.set('n', '<leader>d', vim.diagnostic.setqflist, { desc = 'Diagnostics' })
