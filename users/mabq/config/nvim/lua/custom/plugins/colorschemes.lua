local colorscheme = "tokyonight-night"
local cursorline = true

local applyConfig = function()
	-- Apply colorscheme
	vim.cmd.colorscheme(colorscheme)

	-- Make window separation more visible:

	--   must be set to 3 to show the horizontal split separator
	vim.o.laststatus = 3

	--   increase contrast for window separator color
	vim.api.nvim_set_hl(0, "WinSeparator", {
		link = "LineNr", -- use the same color as line numbers, see `:hi` for all color groups
		-- fg = "Green", -- or use a specific color
	})

	--   change window separator characters
	vim.opt.fillchars = {
		vert = "┆",
		horiz = "┄", -- for this to work `laststatus` must be set to 3
	}

	-- Preferences:
	vim.o.cursorline = cursorline
end

return {
	{
		lazy = false,
		priority = 1000,
		"folke/tokyonight.nvim",
		config = applyConfig,
	},
	-- { "catppuccin/nvim", name = "catppuccin" },
	-- { "rose-pine/neovim", name = "rose-pine" },
}
