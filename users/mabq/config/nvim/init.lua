require("config.options")

-- Plugins
vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' }, -- Default LSP configurations for Neovim
}

-- LSP servers are installed via Mason or Nix
vim.lsp.enable('nixd')
