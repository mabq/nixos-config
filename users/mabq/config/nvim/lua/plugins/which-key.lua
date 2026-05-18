return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

--[[

Use `:checkhealth which-key` if something is not working properly

WhichKey automatically gets the descriptions of your keymaps from the
desc attribute of the keymap. So for most use-cases, you don't need to
do anything else.

NOTE: Use the following memonics:
  <leader>s    search
  <leader>g    git
  <leader>u    UI/toggles
  <leader>x    diagnostics/trouble
  <leader>c    code

--]]
