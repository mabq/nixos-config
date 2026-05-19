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

Learn how Neovim integrates Lua:
  `:h lua-guide`
  `:h lua-guide-modules`
  `:=` is a shortcut for `:lua print(...)`

Learn about Neovim:
  `:h`

Help:
  `<leader>sh` - search help with Telescope
  `:checkhealth [<plugin-name>]`

--]]

-- Must be set before loading plugins, otherwise the wrong mapleader is used
vim.g.mapleader = " " -- used for editor/workspace actions
vim.g.maplocalleader = "," -- used for language/filetype actions

-- Require lazy config
require "config.lazy"
