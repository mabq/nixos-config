-- Read `:help lsp`.
-- Langugage servers must be installed with home-manager.
-- Each language server is configured and loaded in `/after/ftplugin/<language>.lua`

vim.pack.add {
  -- https://github.com/neovim/nvim-lspconfig#quickstart
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}
