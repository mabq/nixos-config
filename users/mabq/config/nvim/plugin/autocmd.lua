local userGroup = vim.api.nvim_create_augroup("user_settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	desc = "Highlight when yanking",
	group = userGroup,
	callback = function()
		(vim.hl or vim.highlight).on_yank()
	end,
})

-- Automatically remove all trailling spaces before saving
autocmd({ "BufWritePre" }, {
	group = userGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Close these windows with q
autocmd("FileType", {
	group = userGroup,
	pattern = {
		-- Check filetype with `:=vim.bo.filetype`
		"checkhealth",
		"help",
		"lspinfo",
		"qf", -- quickfix list
		"nvim-undotree", -- builtin undotree
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- Automatically wrap and check for spell in text filetypes
autocmd("FileType", {
	group = userGroup,
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})
