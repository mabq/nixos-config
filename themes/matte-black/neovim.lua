return {
  "tahayvr/matteblack.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "matteblack"

    -- Make the separator character more visible
    --  Must be set after setting the theme to pick the correct highlight group
    vim.api.nvim_set_hl(0, "WinSeparator", {
      link = "LineNr", -- use the same highlight group as the line numbers
    })
  end,
}

