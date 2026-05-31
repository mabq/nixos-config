-- Must be set before loading plugins, otherwise the wrong mapleader is used.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable new core ui.
--   Adds syntax highlighting to command line.
--   Enter the message buffer with `g<`.
--   https://www.youtube.com/watch?v=h1sCwi0pNyM
require("vim._core.ui2").enable {
  enable = true,
  msg = {
    target = "cmd",
    pager = { height = 0.5 },
    dialog = { height = 0.5 },
    cmd = { height = 0.5 },
    msg = { height = 0.5, timeout = 4500 },
  },
}

-- Require lazy config.
require "config.lazy"

--[[

Startup config files:
  Everything inside the `lua` directory can be required by Lua, e.g. `config.<name>`.

  Lazy.nvim automatically sources all files in the specified `spec.import`.

  Neovim automatically sources all files in `nvim/plugin`, `nvim/after` as part of its startup sequence.
    `:h starting`
    `:h runtimepath`
    `:h standard-path
    `:h init.lua`
    `:h base-directories`
    `:h slow-start`

Learn Lua (the language):
  https://learnxinyminutes.com/lua
  https://www.lua.org/manual/5.5/

Learn how Neovim integrates Lua:
  `:h lua-guide`
  `:h lua-guide-modules`
  `:=` is a shortcut for `:lua print(...)`

Learn about Neovim:
  `:h` - use `gO` to see sections of the help pages
  Restart to apply new configs with `ZR`

Help:
  `<leader>sh` - search help with Telescope
  `:checkhealth [<plugin-name>]`

--]]
