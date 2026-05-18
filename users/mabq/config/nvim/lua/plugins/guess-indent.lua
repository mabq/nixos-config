-- Read notes at the bottom

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

--------------------------------------------------------------------------------

--[[

Default options:

  The Neovim options set above determine how the editor behaves while you type,
  not how the buffer is formatted!

  We use 2 spaces as default, which is the most common convention for all languages.

Global vs Buffer options:

  Default options above are global, meaning they apply for all buffers.

  Those same options can be set per-buffer, when these are set they override
  the global ones.

Guess-indent plugin:

  This plugin will read the first hundred lines of a file and detect whether
  spaces or tabs are used for indentation, and how many colums are used.

  Then it adjusts the local buffer options to match what it sees.

  The important thing is that it respects `.editorconfig` settings.

Editor config:

  `.editorconfig` is a project-level formatting convention file used by most
  editors and IDEs to keep coding styles consistent across a team.

  When you open a buffer, Neovim checks for an `.editorconfig` file, if it finds
  one it sets the local buffer options accordingly:

    .editorconfig               Neovim local buffer option
    --------------------   ->   --------------------------
    indent_style = space        expandtab = true
    indent_style = tab          expandtab = false
    indent_size = 4             shiftwidth = 4
    tab_width = 4               tabstop = 4
    end_of_line                 fileformat

Formatters:

  All the things described above only adjust editor behavior while you type.

  When you run a formatter, it will use its own settings for indentation.

  The cool thing is that some formatters, like stylua, also support editorconfig
  files. When both files are present `.editorconfig` and `.stylua` the latter
  takes presedence.

--]]
