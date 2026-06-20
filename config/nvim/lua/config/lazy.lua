-- Bootstrap lazy.nvim in new setups
--  https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
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
vim.opt.rtp:prepend(lazypath) -- include in runtimepath so that Neovim also looks for files there

-- Load and configure Lazy.nvim
require("lazy").setup {
  spec = {
    { import = "plugins" }, -- this is where lazy.nvim looks for plugin specs
    -- Source the theme file directly
    dofile(vim.fn.expand "$NC_CURRENT_THEME_PATH/neovim.lua") or nil,
  },
  change_detection = {
    notify = false, -- do not notify when changes are found
  },
}

-- Keymaps
vim.keymap.set("n", "<leader>ol", "<CMD>Lazy<CR>", { desc = "Lazy" })

--[[

Configuration:
  https://lazy.folke.io/configuration

Plugin Spec:
  https://lazy.folke.io/spec

  A plugin is considered lazy-loaded if ANY of the following attributes exist
  on the spec: `event`, `cmd`, `ft`, `keys`, `lazy = true`.

Lazy.nvim explained:
  https://www.youtube.com/watch?v=_kPg0VBRxJc&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=4

--]]
