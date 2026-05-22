return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup {
      settings = { save_on_toggle = true },
    }

    -- Highlight current file in menu
    local harpoon_extensions = require "harpoon.extensions"
    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

    -- Add to/Open harppon list
    vim.keymap.set("n", "<leader>oh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon" })
    vim.keymap.set("n", "+", function()
      harpoon:list():add()
    end, { desc = "Add file" })

    -- Set <space>1..<space>5 be my shortcuts to moving to the files
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      vim.keymap.set("n", string.format("<space>%d", idx), function()
        harpoon:list():select(idx)
      end, { desc = string.format("Harpoon %d", idx) })
    end
  end,
}
