return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>tu', '<CMD>UndotreeToggle<CR> | <cmd>wincmd h<cr>', { desc = "Undo Tree" })
  end,
}
