-- Must be set before loading plugins, otherwise the wrong mapleader is used
vim.g.mapleader = " "
vim.g.maplocalleader = "," -- use flash instead to jump

-- Enable new core ui
--  Adds syntax highlighting to command line.
--  Enter the message buffer with `g<`.
--  `:h ui2`
--  https://www.youtube.com/watch?v=h1sCwi0pNyM
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

  `~/.config/nvim/` is the default config directory - to use a different
  directory start Neovim like this:
   `NVIM_APPNAME=<directory> nvim`

  Inside that directory, Neovim will look for the `init.lua` file.

Requering other files:

  Neovim can require any file that is inside a `lua` directory in the
  runtimepath. Check which directories are in the runtimepath with:
   `:echo nvim_list_runtime_paths()`

Direct startup directories:

  Files placed inside these directories are executed automatically by Neovim
  during initialization:

  `plugin/`
    All directories in the runtimepath will be searched for the `plugin`
    sub-directory and all files ending in `.vim` or `.lua` will be sourced (in
    alphabetical order per directory), also in subdirectories.
     `:h load-plugins`

  `ftplugin/`
    Special files that are only sourced for buffers of the given filetype.
    For example: `ftplugin/go.lua` is sourced when the filetype is `go`.
    https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5

  `after/`
    This directory mimics the entire runtime structure (`after/plugin/`,
    `after/ftplugin/`), but Neovim processes it at the absolute end of startup,
    after all standard scripts and plugins have loaded.
    Best for overriding a setting or keymap that a third-party plugin keeps
    trying to overwrite during startup.

  To learn more about special directories, see:
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
