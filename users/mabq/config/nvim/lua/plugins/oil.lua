local detail = false
local toggleDetail = function()
  detail = not detail
  if detail then
    require("oil").set_columns { "icon", "permissions", "size", "mtime" }
  else
    require("oil").set_columns { "icon" }
  end
end

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- documentation strongly recommends loading at startup
  config = function()
    -- Plugin options
    --   https://github.com/stevearc/oil.nvim#options
    require("oil").setup {
      delete_to_trash = true, -- `:h oil-trash`
      cleanup_delay_ms = 500, -- decrese delay to clean oil buffer (default 2000)
      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
      -- view_options = {
      --   show_hidden = true,
      -- },
      -- confirmation = {
      --   border = "rounded",
      -- },
      -- ssh = {
      --   border = "rounded",
      -- },
      -- keymaps_help = {
      --   border = "rounded",
      -- },
    }

    -- Keybinds
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}

--[[

This plugin is used as the default replacement for NetRW.

It displays much faster than Yazi. I am gonna try to get used to it.

I leave Yazi enabled for faster exploration.

--]]
