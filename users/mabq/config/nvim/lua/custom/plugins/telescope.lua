--------------------------------------------------------------------------------
-- Required system packages:
--   ripgrep
--   fd
--
--  Help:
--   `:h telescope.setup()`
--   `:h telescope.builtin`
--   `:h telescope.default.mappings`
--   `:checkhealth telescope`
--
--   Learn how to customize pickers:
--     `:h telescope.builtin[.<picker-name>]`.
--     E.g. `grep_string` is customized to use regex by default, see [Rust regex syntax](https://docs.rs/regex/1.11.1/regex/#syntax).
--
--   Learn about fzf syntax:
--     https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-fzf-nativenvim.
--
--   NOTE: Trouble integration can be really useful.
--   E.g. Use `grep_string` of `live_grep` to obtain a list of files with some specific text in them, refine the list with fzf, then maybe even mark only specific files with <Tab> and then export the list to Trouble.
--

--------------------------------------------------------------------------------
return {
	"nvim-telescope/telescope.nvim",
	version = "*", -- use the latest stable version
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- much better sorting performance
		"nvim-telescope/telescope-ui-select.nvim",
		-- "nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("telescope").setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
					},
				},
				sorting_strategy = "ascending",
			},
			pickers = {
				grep_string = {
					use_regex = true, -- enable regex
				},
			},
			extensions = {
				fzf = {
					-- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
					fuzzy = false, -- exact matches by default
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader><leader>", builtin.resume, { desc = "Search Resume" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Search Git Files" })
		vim.keymap.set("n", "<leader>sl", builtin.live_grep, { desc = "Search Live" })
		vim.keymap.set("n", "<leader>ss", function()
			builtin.grep_string({ search = vim.fn.input("Search: ") })
		end, { desc = "Search String" }) -- big projects
		vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "Search Telescope" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
	end,
}
