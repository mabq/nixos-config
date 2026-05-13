vim.loader.enable() -- enable faster startup by caching compiled Lua modules

-- Enable new core ui
--   Adds syntax highlighting to command line
--   Enter the message buffer with `g<`
--   https://www.youtube.com/watch?v=h1sCwi0pNyM
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

require("mabq.core.variables")
require("mabq.core.options")
require("mabq.core.keymaps")
require("mabq.core.diagnostics")
require("mabq.core.autocommands")
