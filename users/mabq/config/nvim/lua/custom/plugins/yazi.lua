return {
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
		{
			mode = { "n", "v" },
			"<leader>E",
			"<cmd>Yazi toggle<CR>",
			desc = "Resume last yazi session",
		},
		{
			mode = { "n", "v" },
			"<leader><C-e>",
			"<cmd>Yazi cwd<CR>",
			desc = "Open yazi at the current working directory",
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
