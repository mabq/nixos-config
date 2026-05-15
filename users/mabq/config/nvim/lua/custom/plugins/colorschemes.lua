return {
	{
		lazy = false,
		priority = 1000,
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd.colorscheme("tokyonight-night")

			vim.o.laststatus = 3 -- must be set to 3 to show the horizontal split separator

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
		end,
	},
	-- { "catppuccin/nvim", name = "catppuccin" },
	-- { "rose-pine/neovim", name = "rose-pine" },
}
