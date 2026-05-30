-- These options only affect indenting in insert mode!
vim.o.tabstop = 2 -- Columns multiple used to display a horizontal Tab character
vim.o.shiftwidth = 0 -- Columns multiple for one level of (auto)indentation (`0` == 'tabstop')
vim.o.softtabstop = -1 -- Columns multiple for Tab in insert mode (`-1` == `shiftwidth`)
vim.o.expandtab = true -- Whether to insert spaces instead of a Tab character (does not convert existing tabs)

return {
  {
    "nmac427/guess-indent.nvim", -----------------------------------------------
    opts = {
      -- https://github.com/NMAC427/guess-indent.nvim#configuration
      auto_cmd = true, -- whether to automatically execute when openning a buffer (a few milliseconds top) - toggle manually with `:Guess-indent`
      override_editorconfig = false, -- whether to override settings set by `.editorconfig`
      filetype_exclude = { -- filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
      },
      buftype_exclude = { -- buffer types for which the auto-command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
      on_tab_options = { -- config when tabs are detected
        expandtab = false,
      },
      on_space_options = { -- config when spaces are detected
        expandtab = true,
        tabstop = "detected", -- if the option value is 'detected', the value is set to the automatically detected indent size
        softtabstop = "detected",
        shiftwidth = "detected",
      },
    },
  },

  {
    "stevearc/conform.nvim", ---------------------------------------------------
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        mode = { "n", "x" },
        desc = "Format (Conform)",
      },
    },
    opts = {
      -- Make sure these tools are available in the system, check with `:h checkhealth conform`
      -- For configuration options, see `:h conform.setup`
      formatters_by_ft = {
        lua = { "stylua", lsp_format = "never" },
        markdown = { "biome" },
        css = { "biome" },
        javascript = { "biome" },
        typescript = { "biome" },
        json = { "biome" },
        jsonc = { "biome" },
        sh = { "shfmt" },
      },
      default_format_opts = {
        async = true, -- do not block
        lsp_format = "fallback", -- only used when no other formatters are available
        stop_after_first = true, -- by default only apply one, not all in sequence
      },
      format_on_save = true,
      notify_on_error = true,
      notify_no_formatters = true,
    },
  },
}

--[[

Guess-indent:

  This plugin reads the first hundred lines of a file when opened to detect
  whether spaces or tabs are used for indentation and how many colums are used
  for each indentation level.

  It then sets buffer local options to match what it sees. These local options
  override the global options set above.

  The plugin respects editorconfig settings - `.editorconfig` is a
  project-level formatting convention file used by most editors and IDEs to
  keep coding styles consistent across a team.

  When you open a buffer, Neovim checks for an `.editorconfig` file, if it finds
  one it sets the local buffer options accordingly:

    .editorconfig               Neovim local buffer option
    --------------------   ->   --------------------------
    indent_style = space        expandtab = true
    indent_style = tab          expandtab = false
    indent_size = 4             shiftwidth = 4
    tab_width = 4               tabstop = 4
    end_of_line                 fileformat

Conform.nvim:

  All the things described above only adjust editor behavior while you type,
  when you run a formatter, it will use its own settings for indentation.

  The cool thing is that some formatters, like stylua, also support
  editorconfig files. When both files are present (e.g. `.editorconfig` and
  `.stylua`) the latter takes presedence.

  Install formatters using you package manager. For a list of formatters see:
    `:h conform-formatters`
    https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters

  Options to customize a formatter:
    `:h conform.format`
    https://github.com/stevearc/conform.nvim#options

  Verify:
    `:checkhealth conform`
    `:ConformInfo`

--]]
