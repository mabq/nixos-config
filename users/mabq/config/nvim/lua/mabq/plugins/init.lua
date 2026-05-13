vim.pack.add({
	-- Dependencies (Lazygit, Telescope, ...)
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- Plenary, required by many plugins

	{ src = "https://github.com/kdheepak/lazygit.nvim" }, -- Lazygit

	-- Tree-sitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	-- LSP
	--   Langugage servers must be installed with home-manager
	--   Each language server is configured and loaded in `/after/ftplugin/<language>.lua`
	--   https://github.com/neovim/nvim-lspconfig#quickstart
	--   `:h lsp`
	{ src = "https://github.com/neovim/nvim-lspconfig" },

	-- Themes
	{ src = "https://github.com/folke/tokyonight.nvim" },
})

require("mabq.plugins.lazygit")
require("mabq.plugins.tree-sitter")
require("mabq.plugins.undotree")
