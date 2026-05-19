-- s  search
-- g  git
-- u  UI/toggles
-- x  diagnostics/trouble
-- c  code

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 350,
  },
}

--[[

Use `:checkhealth which-key` if something is not working properly

WhichKey automatically gets the descriptions of your keymaps from the
desc attribute of the keymap. So for most use-cases, you don't need to
do anything else.

--]]
