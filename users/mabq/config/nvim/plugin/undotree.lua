-- Load the builtin plugin
--   Not loaded by default, see `:h standard-plugin-list`
vim.cmd.packadd("nvim.undotree")

-- Make undo history persistent
--   See `:h undo-persistence`
vim.o.undodir = vim.fn.stdpath("state") .. "/undo"
vim.o.undofile = true

-- Set a keybind
vim.keymap.set("n", "<leader>u", ":Undotree<CR>", { desc = "Toggle builtin Undotree" })
