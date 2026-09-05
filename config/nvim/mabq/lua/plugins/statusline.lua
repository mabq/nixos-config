return {
  {
    enabled = true,
    "https://github.com/nvim-mini/mini.nvim",
    config = function()
      local statusline = require "mini.statusline"
      statusline.setup { use_icons = true }
    end,
  },
  {
    enabled = false,
    "nvim-lualine/lualine.nvim",
    opts = {
      -- https://github.com/nvim-lualine/lualine.nvim#default-configuration
      sections = {
        -- Show absolute path, with tilde as the home directory
        --   https://github.com/nvim-lualine/lualine.nvim#filename-component-options
        lualine_c = {
          {
            "filename",
            path = 3,
          },
        },
        -- Remove the 'fileformat' section
        lualine_x = { "encoding", "filetype" },
      },
    },
  },
}
