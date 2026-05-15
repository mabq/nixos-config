vim.loader.enable() -- enable faster startup by caching compiled Lua modules

-- VARIABLES -------------------------------------------------------------------
--   `:h lua-guide-variables`
do
	vim.g.mapleader = " " -- must happen before plugins are loaded, otherwise wrong leader will be used
	vim.g.maplocalleader = " "

	vim.g.have_nerd_font = false -- set to true if you have a Nerd Font installed and selected in the terminal

	vim.g.netrw_banner = 0 -- disable NetRW banner
end

-- OPTIONS ---------------------------------------------------------------------
--   `:h vim.o`
--   `:h option-list`
--   `:h lua-guide-options`
--   Configure Neovim Options:
--     https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5
--   Options and variables explained:
--     https://www.youtube.com/watch?v=Cp0iap9u29c&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=6
do
	vim.o.swapfile = false -- disable swap files
	vim.o.backup = false -- do not keep a backup file after overwriting a file

	vim.o.undodir = vim.fn.stdpath("data") .. "/undo" -- set the directory path for undo file
	vim.o.undofile = true -- make undo/redo work even after closing the file, see `:h undo-persistence`

	vim.o.ignorecase = true -- can be overruled by using `\c` or `\C` in the pattern
	vim.o.smartcase = true -- case sensitive if the search pattern contains upper case characters
	vim.o.hlsearch = true -- highlight matches
	vim.o.incsearch = true -- highlight matches while typing
	vim.o.inccommand = "split" -- preview substitutions live, as you type!

	vim.o.tabstop = 2 -- number of spaces to use for tab
	vim.o.shiftwidth = 0 -- use the value of 'tabstop'
	vim.o.shiftround = true -- round indent to multiple of shiftwidth
	vim.o.softtabstop = -1 -- use the value of 'shiftwidth'
	vim.o.expandtab = true -- use spaces when <Tab> is inserted
	vim.o.smartindent = false -- do not use smart autoindenting when starting a new line

	vim.o.list = true -- show <Tab> and <EOL>
	vim.o.listchars = "tab:» ,trail:·,nbsp:␣" -- how to display these whitespace characters

	vim.o.wrap = false -- do not wrap lines by default
	vim.o.breakindent = true -- preserve indentation in wrapped text
	vim.o.linebreak = true -- do not break words when wrapping

	vim.o.foldenable = false -- open all folds by default (toggle with `zi`)

	vim.o.number = true
	vim.o.relativenumber = true
	vim.o.colorcolumn = "0" -- colums to highlight
	vim.o.cursorline = true -- show which line the cursor is on
	vim.o.guicursor = "" -- always show block cursor
	vim.o.confirm = true -- raise a dialog when trying to quit an unsaved buffer
	vim.o.mouse = "a" -- enable all mouse modes, can be useful for resizing splits
	vim.o.laststatus = 3 -- must be set to 3 to show the horizontal split separator
	vim.o.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
	vim.o.showmode = false -- do not show edit mode
	vim.o.signcolumn = "yes" -- keep signcolumn on by default
	vim.o.spelllang = "en_us,es_ec"
	vim.o.splitbelow = true -- horizontal splits to the bottom
	vim.o.splitright = true -- vertical splits to the right
	vim.o.termguicolors = true -- enable 24-bit color in the TUI
	vim.o.timeoutlen = 400 -- decrease mapped sequence wait time
	vim.o.updatetime = 250 -- decrease update time

	-- vim.schedule(function() vim.o.clipboard = 'unnamedplus' end) -- sync clipboard between OS and Neovim (schedule the setting after `UiEnter` because it can increase startup-time)
end

-- KEYMAPS ---------------------------------------------------------------------
do
	-- `:h default-mappings`
	-- `:h lua-guide-mappings`
	-- `:h vim-keymap-set()`
	-- `:h map-table` - possible mods
	-- `:Telescope keymaps`
	-- `:map`
	--
	-- <leader>f    file/find
	-- <leader>g    git
	-- <leader>s    search
	-- <leader>u    UI/toggles
	-- <leader>x    diagnostics/trouble
	-- <leader>c    code

	-- Without modifier key --

	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search hightlights" })

	vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line (cursor in place)" })

	vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q default behavior" })

	vim.keymap.set("x", "<", "<gv", { desc = "Decrease indentation (keep selection)" })
	vim.keymap.set("x", ">", ">gv", { desc = "Increase indentation (keep selection)" })

	-- With Ctrl --

	vim.keymap.set("n", "<C-f>", ":Ex<CR>", { desc = "Netrw" })

	vim.keymap.set("n", "<C-s>", ":!tmux neww tmux-sessionizer<CR>", { desc = "Run tmux-sessionizer", silent = true })

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

	-- With Leader --

	vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
	vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
	vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete withou yanking" })

	vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

	vim.keymap.set("n", "<leader>su", ":Undotree<CR>", { desc = "Toggle builtin Undotree" })

	-- vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- remane all instances of word under cursor

	-- vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true }) -- make the current file executable

	-- vim.keymap.set('n', '<leader><leader>X', '<cmd>source %<CR>', { desc = 'Source file' }) -- refresh lua configurations
end

-- DIAGNOSTICS -----------------------------------------------------------------
--   Neovim framework for displaying errors or warnings from external tools,
--   such as LSP servers or linters.
--   `:h vim.diagnostic`
do
	-- Configuration --
	--   `:h vim.diagnostic.Opts`
	vim.diagnostic.config({
		underline = false,
		virtual_text = true, -- show virtual at the end of the line, show float with `<C-w>d`
		virtual_lines = false, -- feels kind of disorienting
		float = {
			border = "rounded",
			source = "if_many", -- only show sources if there is more than one
		},
		severity_sort = true, -- most significant diagnostics first
		jump = { -- auto open the diagnostic float when jumping with `]d` or `[d`
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				})
			end,
		},
	})

	-- Keymaps --
	--   `:h diagnostic-defaults`
	vim.keymap.set("n", "<leader>xl", vim.diagnostic.setloclist, {
		desc = "Open diagnostics [l]ocation list",
	})

	vim.keymap.set("n", "<leader>ud", function()
		local status = vim.diagnostic.is_enabled()
		vim.diagnostic.enable(not status)
		print((status and "Disabled" or "Enabled") .. " Diagnostics")
	end, { desc = "Toggle diagnostics" })
end

-- AUTOCOMMANDS ----------------------------------------------------------------
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

--------------------------------------------------------------------------------

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
