return {
  "stevearc/oil.nvim",
  dependencies = { "folke/snacks.nvim" },
  lazy = false, -- documentation strongly recommends loading at startup
  config = function()
    require("oil").setup {
      -- https://github.com/stevearc/oil.nvim#options
      delete_to_trash = true, -- `:h oil-trash`
      cleanup_delay_ms = 500, -- decrese delay to clean oil buffer (default 2000) to avoid oil buffer appearing when pressing Ctrl-i/Ctrl-o
      use_default_keymaps = false, -- default keymaps conflict with window navigation
      keymaps = {
        -- Default plugin keymaps
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        -- Custom keymaps
        ["q"] = { "actions.close", mode = "n", nowait = true }, -- easier close
        ["gv"] = { "actions.select", opts = { vertical = true } },
        ["gh"] = { "actions.select", opts = { horizontal = true } },
        ["<C-r>"] = "actions.refresh",
      },
      view_options = {
        show_hidden = true,
      },
    }

    -- Global keybinds
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })

    -- Rename files with LSP
    --   https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("plugins_oil", { clear = true }),
      pattern = "OilActionsPost",
      callback = function(event)
        if event.data.actions[1].type == "move" then
          Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
        end
      end,
    })
  end,
}

--[[

This plugin is used as the default replacement for NetRW.

It displays much faster than Yazi. I am gonna try to get used to it.

I leave Yazi enabled for faster exploration.

--]]
