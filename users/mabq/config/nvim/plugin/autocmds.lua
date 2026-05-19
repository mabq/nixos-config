local userGroup = vim.api.nvim_create_augroup("user_settings", { clear = true }) -- clear to avoid duplication when reloading
local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------------------------------
-- On filetype
--------------------------------------------------------------------------------
-- Check filetype with `:=vim.bo.filetype`

-- Close with Ctrl-c
autocmd("FileType", {
  group = userGroup,
  pattern = {
    "checkhealth",
    "gitsigns-blame", -- gitsigns plugin
    "help",
    "lspinfo",
    "nvim-undotree", -- builtin undotree
    "qf", -- quickfix list
    "vim", -- the window that I keep opening accidentally when trying to quit
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "<C-c>", function()
        vim.cmd "close"
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Automatically wrap and spellcheck
autocmd("FileType", {
  group = userGroup,
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

--------------------------------------------------------------------------------
-- On buffer write
--------------------------------------------------------------------------------

-- Automatically remove all trailling spaces before saving
autocmd({ "BufWritePre" }, {
  group = userGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

--------------------------------------------------------------------------------
-- On yank
--------------------------------------------------------------------------------
autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = userGroup,
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
