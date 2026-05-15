return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		{ "nvim-lua/plenary.nvim", lazy = true },
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = { save_on_toggle = true },
		})

		local harpoon_extensions = require("harpoon.extensions")
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

		-- Add to/Open harppon list
		vim.keymap.set("n", "<leader>+", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>-", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- Quickly move through the main 4 harppon files
		vim.keymap.set("n", "<left>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<down>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<up>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<right>", function()
			harpoon:list():select(4)
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<S-left>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<S-right>", function()
			harpoon:list():next()
		end)
	end,
}
