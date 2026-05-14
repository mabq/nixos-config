-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Enable new core ui
--   Adds syntax highlighting to command line
--   Enter the message buffer with `g<`
--   https://www.youtube.com/watch?v=h1sCwi0pNyM
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

--------------------------------------------------------------------------------

-- VARIABLES
--   `:help lua-guide-variables`

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

--------------------------------------------------------------------------------

-- OPTIONS
--   [Options and variables explained](https://www.youtube.com/watch?v=Cp0iap9u29c&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=6)
--   [Configure Neovim Options](https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5)
--   `:help lua-guide-options`
--   `:help vim.o`
--   `:option-list`

do
	vim.o.guicursor = ""

	vim.o.number = true
	vim.o.relativenumber = true

	vim.o.mouse = "a"

	vim.o.showmode = false

	-- Sync clipboard between OS and Neovim.
	--  Schedule the setting after `UiEnter` because it can increase startup-time.
	--  Remove this option if you want your OS clipboard to remain independent.
	--  See `:help 'clipboard'`
	-- vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

	vim.o.tabstop = 2 -- see GuessIndent plugin
	vim.o.shiftwidth = 0 -- do not change!
	vim.o.softtabstop = -1 -- do not change!
	vim.o.expandtab = true
	vim.o.shiftround = true

	vim.o.smartindent = true

	vim.o.wrap = false
	vim.o.breakindent = true -- preserve indentation in wrapped text
	vim.o.linebreak = true -- do not break words when wrapping

	vim.o.swapfile = false
	vim.o.backup = false
	vim.o.undodir = vim.fn.stdpath("state") .. "/undo"
	vim.o.undofile = true -- make undo persistent, see `:h undo-persistence`

	vim.o.hlsearch = true
	vim.o.incsearch = true
	vim.o.ignorecase = true
	vim.o.smartcase = true

	vim.o.inccommand = "split" -- preview substitutions live, as you type!

	vim.o.termguicolors = true

	vim.o.scrolloff = 8
	vim.o.signcolumn = "yes"
	vim.opt.isfname:append("@-@") -- add `@` as a valid filename character

	vim.o.updatetime = 250
	vim.o.timeoutlen = 300

	vim.o.colorcolumn = "80"
	vim.o.cursorline = true

	vim.opt.spelllang = { "en", "es" }

	vim.o.splitright = true
	vim.o.splitbelow = true

	vim.o.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

	-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
	--  instead raise a dialog asking if you wish to save the current file(s)
	--  See `:help 'confirm'`
	vim.o.confirm = true
end

--------------------------------------------------------------------------------

-- KEYMAPS
--   `:h default-mappings`
--   `:h lua-guide-mappings`
--   `:h vim-keymap-set()`
--   `:h map-table` - possible mods
--   `:Telescope keymaps`         - list all keymaps
--   `:[verbose] map [keybind]`   - check all/specific keymap

-- Without modifier key --

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search hightlight" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line (cursor in place)" })
-- vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next match (centered)' })
-- vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous match (centered)' })

-- vim.keymap.set('n', '<down>', '<C-e>', { desc = 'Scroll down (keep current line)' })
-- vim.keymap.set('n', '<up>', '<C-y>', { desc = 'Scroll up (keep current line)' })

vim.keymap.set("x", "<", "<gv", { desc = "Decrease indentation (keep selection)" })
vim.keymap.set("x", ">", ">gv", { desc = "Increase indentation (keep selection)" })

-- vim.keymap.set("x", "<right>", "an", { remap = true, desc = "Select parent (outer) node" })
-- vim.keymap.set("x", "<left>", "in", { remap = true, desc = "Select child (inner) node" })

-- vim.keymap.set('v', 'J', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move line down' })
-- vim.keymap.set('v', 'K', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move line up' })

-- vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable Q default behavior' })

-- vim.keymap.set('c', '<down>', function() if vim.fn.pumvisible() == 1 then return '<c-n>' end return '<down>' end, { expr = true, desc = 'Select next menu item' })
-- vim.keymap.set('c', '<up>', function() if vim.fn.pumvisible() == 1 then return '<c-p>' end return '<up>' end, { expr = true, desc = 'Select previous menu item' })

-- Ctrl --

vim.keymap.set("n", "<C-f>", ":Ex<CR>", { desc = "Netrw" })

vim.keymap.set("n", "<C-s>", ":!tmux neww tmux-sessionizer<CR>", { desc = "Run tmux-sessionizer", silent = true })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-Left>", ":vertical resize -4<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +4<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", ":resize -4<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Up>", ":resize +4<CR>", { desc = "Increase window height" })

vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>", { desc = "Quickfix next" })
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>", { desc = "Quickfix previous" })

-- Leader --

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete withou yanking" })

vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

vim.keymap.set("n", "<leader>u", ":Undotree<CR>", { desc = "Toggle builtin Undotree" })

-- vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- remane all instances of word under cursor

-- vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true }) -- make the current file executable

-- vim.keymap.set('n', '<leader><leader>X', '<cmd>source %<CR>', { desc = 'Source file' }) -- refresh lua configurations

--------------------------------------------------------------------------------

-- DIAGNOSTICS
--   `:help vim.diagnostic.Opts`

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--------------------------------------------------------------------------------

-- AUTOCOMMANDS
--   `:h default-autocmds`
--   `:h lua-guide-autocommands`
--   `:h nvim_create_autocmd()`
--   `:h events`

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local myGroup = augroup("user_settings", { clear = true })

autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = augroup("highlightYank", {}),
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- Automatically remove all trailling spaces before saving
autocmd({ "BufWritePre" }, {
	group = myGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Close these windows with q
autocmd("FileType", {
	group = myGroup,
	pattern = {
		-- Check filetype with `:=vim.bo.filetype`
		"checkhealth",
		"help",
		"lspinfo",
		"qf", -- quickfix list
		"nvim-undotree", -- builtin undotree
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- Automatically wrap and check for spell in text filetypes
autocmd("FileType", {
	group = myGroup,
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- autocmd('BufEnter', {
--   group = myGroup,
--   callback = function()
--     if vim.bo.filetype == 'zig' then
--       vim.cmd.colorscheme 'tokyonight-night'
--     else
--       vim.cmd.colorscheme 'rose-pine-moon'
--     end
--   end,
-- })

-- -- Go to last location on open
-- autocmd('BufReadPost', {
--   group = myGroup,
--   callback = function(event)
--     local exclude = { 'gitcommit' }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
--       return
--     end
--     vim.b[buf].lazyvim_last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

---- Automatically create directory on save
-- autocmd({ 'BufWritePre' }, {
--   group = myGroup,
--   callback = function(event)
--     if event.match:match '^%w%w+:[\\/][\\/]' then
--       return
--     end
--     local file = vim.uv.fs_realpath(event.match) or event.match
--     vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
--   end,
-- })

-- Notes:
--   [Autocmds explanation in the context of LSP](https://youtu.be/HL7b63Hrc8U?si=CBt_Hz8IXrJAgear&t=926)
--   `:h lua-guide-autocommands`
--   `:h events`
