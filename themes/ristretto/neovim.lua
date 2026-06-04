return {
  "gthelding/monokai-pro.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai-pro").setup {
      filter = "ristretto",
      override = function()
        return {
          NonText = { fg = "#948a8b" },
          MiniIconsGrey = { fg = "#948a8b" },
          MiniIconsRed = { fg = "#fd6883" },
          MiniIconsBlue = { fg = "#85dacc" },
          MiniIconsGreen = { fg = "#adda78" },
          MiniIconsYellow = { fg = "#f9cc6c" },
          MiniIconsOrange = { fg = "#f38d70" },
          MiniIconsPurple = { fg = "#a8a9eb" },
          MiniIconsAzure = { fg = "#a8a9eb" },
          MiniIconsCyan = { fg = "#85dacc" }, -- same value as MiniIconsBlue for consistency
        }
      end,
    }
    vim.cmd.colorscheme "monokai-pro"

    -- Make the separator character more visible
    --  Must be set after setting the theme to pick the correct highlight group
    vim.api.nvim_set_hl(0, "WinSeparator", {
      link = "LineNr", -- use the same highlight group as the line numbers
    })
  end,
}
