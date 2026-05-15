--------------------------------------------------------------------------------

-- Learn Lua
--   https://learnxinyminutes.com/lua

-- Learn how Neovim integrates Lua:
--   `:h lua-guide`
--   `:h lua-guide-modules`
--   `:=` is a shortcut for `:lua print(...)`

-- Learn about Neovim initialization:
--   `:h starting`
--   `:h runtimepath`
--   `:h standard-path
--   `:h init.lua`
--   `:h base-directories`
--   `:h slow-start`
--   Everthing under `lua/custom/plugins` is sourced by lazy.nvim as instructed
--   in this file.
--   Everything under `plugin` is sourced automatically by Neovim by default.

-- Check for errors:
--   `:checkhealth`

-- For help about everything else:
--   `:h`

--------------------------------------------------------------------------------

-- Map leaders must be set before plugins are loaded
vim.g.mapleader = " " -- used for editor/workspace actions
vim.g.maplocalleader = "," -- used for language/filetype actions

--------------------------------------------------------------------------------

-- Lazy.nvim
--   https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
-- Add lazy to the `runtimepath`, this allows us to `require` it.
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
--   https://lazy.folke.io/configuration
require("lazy").setup({ import = "custom/plugins" }, {
	change_detection = { notify = false },
})

--------------------------------------------------------------------------------
