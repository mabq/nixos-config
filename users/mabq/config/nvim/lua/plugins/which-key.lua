return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 350,
    icons = {
      -- breadcrumb = "",
      -- separator = "",
      group = "",
      mappings = false, -- no icons
    },
    spec = {
      { '<leader>o', group = 'Open' },
      { '<leader>s', group = 'Search' },
      { '<leader>sn', group = 'Neovim' },
      { '<leader>t', group = 'Toggle' },

      -- Give names to Neovim Groups
      -- { 'gr', group = 'LSP', mode = { 'n' } },

    },
    filter = function(mapping)
      -- Use "(which-key-hide)" in the description of a keymap to hide it from which-key menu
      return mapping.desc and mapping.desc ~= "(which-key-hide)"
    end
  },
}

--[[

Use `:checkhealth which-key` if something is not working properly.

WhichKey automatically gets the descriptions of your keymaps from the desc
attribute of the keymap. So for most use-cases, you don't need to do anything
else.

--]]
