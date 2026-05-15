-- Apply desired color scheme
vim.cmd.colorscheme("tokyonight-night")

-- Increase contrast for window separator color
vim.api.nvim_set_hl(0, "WinSeparator", {
	link = "LineNr", -- link to another hi color, see `:hi`
	-- fg = "Green", -- or use a specific color
})

-- Change window separator characters
vim.opt.fillchars = {
	vert = "┆",
	horiz = "┄", -- for this to work `laststatus` must be set to 3
}
