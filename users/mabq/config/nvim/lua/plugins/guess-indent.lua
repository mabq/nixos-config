--------------------------------------------------------------------------------
-- Default options
--------------------------------------------------------------------------------

vim.o.tabstop = 2 -- column multiple used to display a horizontal Tab character
vim.o.shiftwidth = 0 -- how many columns make up one level of (auto)indentation (`0` to use 'tabstop' value)
vim.o.softtabstop = -1 -- how many columns for Tab in insert mode (`-1` to use same columns as shiftwidth)
vim.o.expandtab = true -- whether to insert spaces instead of Tab in insert mode (does not convert existing tabs)

--------------------------------------------------------------------------------
-- Guess-indent
--------------------------------------------------------------------------------

-- See plugin configuration options
--   https://github.com/NMAC427/guess-indent.nvim#configuration
return {
  "nmac427/guess-indent.nvim",
  opts = {
    auto_cmd = true, -- whether to automatically execute when openning a buffer (a few milliseconds top) - toggle manually with `:Guess-indent`
    override_editorconfig = false, -- whether to override settings set by `.editorconfig`
    filetype_exclude = { -- filetypes for which the auto command gets disabled
      "netrw",
      "tutor",
    },
    buftype_exclude = { -- buffer types for which the auto command gets disabled
      "help",
      "nofile",
      "terminal",
      "prompt",
    },
    on_tab_options = { -- config when tabs are detected
      ["expandtab"] = false,
    },
    on_space_options = { -- config when spaces are detected
      ["expandtab"] = true,
      ["tabstop"] = "detected", -- If the option value is 'detected', The value is set to the automatically detected indent size.
      ["softtabstop"] = "detected",
      ["shiftwidth"] = "detected",
    },
  },
}
