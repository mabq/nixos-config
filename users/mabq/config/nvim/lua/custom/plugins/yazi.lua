return {
	enable = false,
	"mikavilpas/yazi.nvim",
	version = "*", -- use the latest stable version
	event = "VeryLazy",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	keys = {
		{
			mode = { "n", "v" },
			"<leader>e",
			"<cmd>Yazi<CR>",
			desc = "Open yazi at the current file",
		},
	},
	opts = {
		open_for_directories = false,
		highlight_groups = {
			-- do not change the background color of the selected buffer.
			hovered_buffer = { bg = "none" },
			hovered_buffer_in_same_directory = { bg = "none" },
		},
		keymaps = {
			show_help = "?",
		},
	},
}
