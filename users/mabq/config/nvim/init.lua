-- Learn about Lua (the language):
--  https://learnxinyminutes.com/lua/

-- Learn how Lua integrates with Neovim:
--  `:help lua-guide`
--  `:help lua-guide-modules`

-- Learn about runtime files:
--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#runtime-files

require("mabq")

-------------------------------------------------------------------------------

--  Intro to `vim.pack`
--
--  `vim.pack` is a new plugin manager built into Neovim, which provides a Lua
--  interface for installing and managing plugins.
--
--  See `:help vim.pack`, `:help vim.pack-examples` or the excellent blog post
--  from the creator of vim.pack and mini.nvim:
--    https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()

-------------------------------------------------------------------------------
-- friendly-snippets provides the "data" (the library of templates).
-- LuaSnip provides the "engine" (the logic that expands the data and handles the jumping).
-- nvim-cmp provides the "UI" (the menu you see while typing).
-------------------------------------------------------------------------------
