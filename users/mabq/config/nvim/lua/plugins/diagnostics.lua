-- Neovim diagnostics config --
--   `:h vim.diagnostic.Opts`
vim.diagnostic.config({
  -- Show virtual text at the end by default, toggle to virtual lines with keybind below
  virtual_text = true, -- at the end of the line
  virtual_lines = false, -- in virtual lines

  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  jump = {
    on_jump = function(_, bufnr) -- auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
})

-- Keymaps --
vim.keymap.set("", "<leader>tv", function()
  local config = vim.diagnostic.config() or {}
  if config.virtual_text then
    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  else
    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  end
end, { desc = "Virtual Lines (LSP)" })

return {
  -- enabled = false,
  -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- config = function()
  --
  --   -- Neovim diagnostics config --
  --   --   `:h vim.diagnostic.Opts`
  --   vim.diagnostic.config({
  --     -- Show virtual text at the end by default, toggle to virtual lines with keybind below
  --     virtual_text = true, -- at the end of the line
  --     virtual_lines = false, -- in virtual lines
  --
  --     severity_sort = true,
  --     float = { border = 'rounded', source = 'if_many' },
  --     underline = { severity = { min = vim.diagnostic.severity.WARN } },
  --
  --     jump = {
  --       on_jump = function(_, bufnr) -- auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  --         vim.diagnostic.open_float {
  --           bufnr = bufnr,
  --           scope = 'cursor',
  --           focus = false,
  --         }
  --       end,
  --     },
  --   })
  --
  --   -- Keymaps --
  --   vi.keymap.set("", "<leader>tv", function()
  --     local config = vim.diagnostic.config() or {}
  --     if config.virtual_text then
  --       vim.diagnostic.config { virtual_text = false, virtual_lines = true }
  --     else
  --       vim.diagnostic.config { virtual_text = true, virtual_lines = false }
  --     end
  --   end, { desc = "Virtual Lines (LSP)" })
  --
  -- end
}

--[[

Diagnostics is a Neovim builtin, the plugin just puts the info into separate virtual lines
--]]
