-- s  search
-- g  git
-- u  UI/toggles
-- x  diagnostics/trouble
-- c  code

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 350,
    icons = {
      -- breadcrumb = "",
      -- separator = "",
      -- group = "",
      mappings = false, -- no icons
    },
    spec = {
      { '<leader>s', group = 'Search/Set' },
      { '<leader>h', group = 'Harpoon' },
      { '<leader>t', group = 'Toggle' },
    },
    filter = function(mapping)
      -- Use "(which-key-hide)" in the description of a keymap to hide it from which-key menu
      return mapping.desc and mapping.desc ~= "(which-key-hide)"
    end
  },
}

--[[

Use `:checkhealth which-key` if something is not working properly

WhichKey automatically gets the descriptions of your keymaps from the
desc attribute of the keymap. So for most use-cases, you don't need to
do anything else.

--]]
