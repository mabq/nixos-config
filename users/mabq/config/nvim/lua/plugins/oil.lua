return {
  "stevearc/oil.nvim",
  lazy = false, -- documentation strongly recommends loading at startup
  config = function()
    local detail = false -- closure to keep show detail state
    local toggle_permissions = function()
      detail = not detail
      if detail then
        require("oil").set_columns { "icon", "permissions", "size", "mtime" }
      else
        require("oil").set_columns { "icon" }
      end
    end

    require("oil").setup {
      -- See options https://github.com/stevearc/oil.nvim#options
      delete_to_trash = true, -- `:h oil-trash`
      cleanup_delay_ms = 500, -- decrese delay to clean oil buffer (default 2000) to avoid oil buffer appearing when pressing Ctrl-i/Ctrl-o
      keymaps = {
        -- Plugin keybinds
        ["q"] = { "actions.close", mode = "n", nowait = true }, -- easier close
        ["gp"] = {
          callback = toggle_permissions,
          mode = "n",
          desc = "Show/hide permissions",
        },
        ["gd"] = { "actions.cd", mode = "n" },
        ["gt"] = { "actions.toggle_trash", mode = "n" },
      },
      view_options = {
        show_hidden = true,
      },
    }

    -- Global keybinds
    vim.keymap.set("n", "<leader>Oil", "<CMD>Oil<CR>", { desc = "Oil" })
  end,
}

--[[

This plugin is used as the default replacement for NetRW.

It displays much faster than Yazi. I am gonna try to get used to it.

I leave Yazi enabled for faster exploration.

--]]
