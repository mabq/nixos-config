-- Load the builtin plugin (not loaded by default)
vim.cmd.packadd("nvim.undotree")

vim.keymap.set("n", "<leader>u", ":Undotree<CR>", { desc = "Open Undotree" })
