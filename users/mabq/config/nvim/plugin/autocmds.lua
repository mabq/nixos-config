local group = vim.api.nvim_create_augroup("general_autocommands", { clear = true }) -- clean autocommands before recreating them

--------------------------------------------------------------------------------
-- Based on filetype
--   Check filetype with `:=vim.bo.filetype`
--------------------------------------------------------------------------------

-- Close with q
vim.api.nvim_create_autocmd("FileType", {
  group = group,
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
      vim.keymap.set("n", "q", function()
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
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "text",
    "plaintex",
    "typst",
    "gitcommit",
    "markdown",
  },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

--------------------------------------------------------------------------------
-- On buffer pre-write
--------------------------------------------------------------------------------

-- Remove all trailling spaces before saving
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

--------------------------------------------------------------------------------
-- On yank
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = group,
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
