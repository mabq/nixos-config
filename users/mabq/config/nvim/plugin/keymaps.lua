-- Help
--   `:h default-mappings`
--   `:h lua-guide-mappings`
--   `:h vim-keymap-set()`
--   `:h map-table` - possible mods
--   `:Telescope keymaps`
--   `:map`

-- Lazy memonics
--   <leader>f    file/find
--   <leader>g    git
--   <leader>s    search
--   <leader>u    UI/toggles
--   <leader>x    diagnostics/trouble
--   <leader>c    code

-- Map arguments:
--   `remap` - whether to allow the keymap to trigger other keymaps (default `false`)
--   `silent` - whether to show the command being executed in the command line (default `false`)
--   `expr` - whether to use the returned value of the RHS as the keymap (default `false`).
--   `buffer` - whether to restrict the keymap to a specific file or buffer (default `nil`)
--   `desc` - description of the keymap (default `nil`)
--   `nowait` - whether to disable timeout delay if keys partially overlap (default: `false`)

-- Options ---------------------------------------------------------------------

vim.o.timeoutlen = 400 -- decrease mapped sequence wait time

-- No modifire key keymaps -----------------------------------------------------

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search hightlights" })

vim.keymap.set("n", "j", function()
	local count = vim.v.count
	if count == 0 then
		return "gj"
	else
		return "j"
	end
end, { expr = true })

vim.keymap.set("n", "k", function()
	local count = vim.v.count
	if count == 0 then
		return "gk"
	else
		return "k"
	end
end, { expr = true })

vim.keymap.set("n", "<down>", "<C-e>", { desc = "Scroll down (keep line focus)" })
vim.keymap.set("n", "<up>", "<C-y>", { desc = "Scroll up (keep line focus)" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line (cursor in place)" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q default behavior" })

-- make the default mappings automatically open the diagnostic float when jumping to it
vim.keymap.set("n", "]d", function() -- TODO: move
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "[d", function() -- TODO: move
	vim.diagnostic.jump({ count = -1, float = true })
end)

vim.keymap.set("n", "]]", "<cmd>cnext<CR>", { silent = true }) -- TODO: move
vim.keymap.set("n", "[[", "<cmd>cprev<CR>", { silent = true }) -- TODO: move

vim.keymap.set("x", "<", "<gv", { desc = "Decrease indentation (keep selection)" })
vim.keymap.set("x", ">", ">gv", { desc = "Increase indentation (keep selection)" })

vim.keymap.set("x", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move line/s down" })
vim.keymap.set("x", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move line/s up" })

-- Control key keymaps ---------------------------------------------------------

vim.keymap.set("n", "<C-e>", ":Ex<CR>", { desc = "Netrw" })

vim.keymap.set("n", "<C-s>", ":!tmux neww tmux-sessionizer<CR>", { desc = "Run tmux-sessionizer", silent = true }) -- TODO: Move

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

vim.keymap.set("n", "<C-Left>", "<c-w>5<", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<c-w>5>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", "<C-W>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Up>", "<C-W>+", { desc = "Increase window height" })

-- vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
-- vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "Quickfix previous" })

-- Meta keymaps ----------------------------------------------------------------

vim.keymap.set({ "n", "x" }, "<M-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set({ "n", "x" }, "<M-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })

-- Leader keymaps --------------------------------------------------------------

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete withou yanking" })

-- vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" }) -- TODO: Move

-- vim.keymap.set("n", "<leader>su", ":Undotree<CR>", { desc = "Toggle builtin Undotree" }) -- TODO: move

-- vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- remane all instances of word under cursor
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
-- vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file (refresh Lua configurations)" })
-- vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
