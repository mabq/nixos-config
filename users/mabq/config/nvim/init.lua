-- Must be set before loading plugins, otherwise the wrong mapleader is used
vim.g.mapleader = " "
vim.g.maplocalleader = "," -- not needed because of flash plugin

-- Enable new core ui
--   Adds syntax highlighting to command line.
--   Enter the message buffer with `g<`.
--   `:h ui2`
--   https://www.youtube.com/watch?v=h1sCwi0pNyM
require("vim._core.ui2").enable {
  enable = true,
  msg = {
    targets = "cmd",
    cmd = { height = 0.5 },
    dialog = { height = 0.5 },
    msg = { height = 0.5, timeout = 4500 },
    pager = { height = 0.5 },
  },
}

-- Require lazy config
require "config.lazy"

--[[

Default config directory:

  `~/.config/nvim/` is the default config directory, in there Neovim will look
  for a file called `init.lua`.

  Use `NVIM_APPNAME=<directory> nvim` to instruct Neovim to look for `init.lua`
  in a different directory.

Requering other files:

  You can require any file that is inside a `<runtimepath>/lua/` directory.

  The runtimepath is simply a list of directories where Neovim will look for
  lua files. Use the following command to check the runtimepath:
    `:echo nvim_list_runtime_paths()`

Startup sequence:

  This is the first file sourced at startup, from here we source
  `./lua/config/lazy.lua` which will source all plugin files.

  All files inside `~/.config/nvim/plugin/..` are automatically sourced by
  Neovim as part of the startup sequence.
    `:h starting`
    `:h runtimepath`
    `:h standard-path
    `:h init.lua`
    `:h base-directories`
    `:h slow-start`

To learn about Lua (the language), see:

  https://learnxinyminutes.com/lua
  https://www.lua.org/manual/5.5/
  https://youtu.be/CuWfgiwI73Q?si=LH_HTvk3EHwJNyjM

To learn how Neovim integrates Lua, see:

  `:h lua-guide`
  `:h lua-guide-modules`
  `:=` is a shortcut for `:lua print(...)`

To learn about Neovim, see:

  `:h` - use `gO` to see sections of the help pages
  `<leader>sh` - search help with Telescope

Tips:

  Restart Neovim to apply new configs with `ZR` or `:restart`
  Check for errors with `:checkhealth [<plugin-name>]`

--]]
