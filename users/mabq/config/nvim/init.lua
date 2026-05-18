--[[

Startup config files:

  Everything inside the `lua` directory can be required by Lua, e.g. the
  config files we require below.

  Lazy.nvim automatically imports all plugin specs - the directory used
  to contain all plugin specs is defined in `config/lazy.lua`.

  There are some special directories (e.g. `after`) that Neovim automatically
  sources at startup. See:
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

Check for errors:
  `:checkhealth`

--]]

require "config"
