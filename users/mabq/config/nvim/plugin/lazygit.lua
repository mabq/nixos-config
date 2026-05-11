vim.pack.add{
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Plenary, required by many plugins
  { src = 'https://github.com/kdheepak/lazygit.nvim' }, -- Lazygit
}

vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Open LazyGit' })
