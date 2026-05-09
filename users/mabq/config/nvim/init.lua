require("config.options")

-- Plugins
vim.pack.add{
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Plenary, required by many plugins
  { src = 'https://github.com/neovim/nvim-lspconfig' }, -- https://github.com/neovim/nvim-lspconfig#quickstart
  { src = 'https://github.com/kdheepak/lazygit.nvim' }, -- Lazygit
}

-- LSP servers are installed via Mason or Nix
vim.lsp.enable('nixd')
vim.lsp.enable('lua_ls')

-- vim.lsp.config('lua_ls', {
--   settings = {
--     Lua = {
--       runtime = 'LuaJIT',
--     },
--     diagnostics = {
--       globals = {
--         'vim',
--         'require'
--       }
--     },
--     workspace = {
--       library = vim.api.nvim_get_runtime_file("", true),
--     },
--     telemetry = {
--       enable = false,
--     },
--   },
-- })

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })

