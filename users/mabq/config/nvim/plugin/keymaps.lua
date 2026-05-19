--[[

Help:
  `:h default-mappings`
  `:h lua-guide-mappings`
  `:h vim-keymap-set()`
  `:h map-table` - possible mods
  `:Telescope keymaps`
  `:map`

What each map argument does?
  `remap` - whether to allow the keymap to trigger other keymaps (default `false`)
  `silent` - whether to show the command being executed in the command line (default `false`)
  `expr` - whether to use the returned value of the RHS as the keymap (default `false`).
  `buffer` - whether to restrict the keymap to a specific file or buffer (default `nil`)
  `desc` - description of the keymap (default `nil`)
  `nowait` - whether to disable timeout delay if keys partially overlap (default: `false`)

--]]

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

-- vim.o.timeoutlen = 400 -- edit mapped sequence wait time (default 1000)

--------------------------------------------------------------------------------
-- Remove default keymaps
--------------------------------------------------------------------------------

-- Disable Q
vim.keymap.set("n", "Q", "<nop>", { desc = "(which-key-hide)" })

--------------------------------------------------------------------------------
-- Improve default keymaps
--------------------------------------------------------------------------------

-- Use display lines (not real lines) to move up/down
vim.keymap.set("n", "k", function()
  local count = vim.v.count
  if count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true, desc = "Line up" })

vim.keymap.set("n", "j", function()
  local count = vim.v.count
  if count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true, desc = "Line down" })

-- Automatically open diagnostic message with next/previous
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Previous diagnotic" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

-- Don't move cursor position when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join" })

-- Keep visual selection after indenting to be able to keep indenting
vim.keymap.set("x", "<", "<gv", { desc = "Indent more" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent less" })

--------------------------------------------------------------------------------
-- Override default keymaps
--------------------------------------------------------------------------------

-- Scroll window without losing line focus
vim.keymap.set('n', '<down>', '<C-e>', { desc = 'Scroll down' })
vim.keymap.set('n', '<up>', '<C-y>', { desc = 'Scroll up' })

-- System clipboard / Default register --
--   In visual mode `Y` yanks the whole line by default. Use `yy` in normal mode instead.
--   We use it to yank the selected text to system clipboard.
vim.keymap.set("x", "Y", [["+y]], { desc = "Yank to clipboard" })
--   In visual mode `D` deletes the entire line by default. Use `dd` in normal mode instead.
--   We use it to delete the selected text without affecting default register, so you can paste the same content again elsewhere.
vim.keymap.set("x", "D", [["_d]], { desc = "Delete without yanking" })
--   In visual mode `P` paste the content before cursor (never really used in visual mode)
--   We use it to paste over the selected text without affecting the default register.
vim.keymap.set("x", "P", [["_dP]], { desc = "Paste without yanking" })

-- Easily move selected lines up/down
--   In visual mode `J`/`K` do the same things that in normal mode. No reason to keep them.
--   We use them to move selected lines up/down.
vim.keymap.set("x", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move line/s up" })
vim.keymap.set("x", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move line/s down" })

--------------------------------------------------------------------------------
-- Create new keymaps
--------------------------------------------------------------------------------

-- Clear matched hightlights on Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

-- Easier window management
--   Move between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
--   Resize windows
vim.keymap.set("n", "<C-Left>", "<c-w>5<", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<c-w>5>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", "<C-W>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Up>", "<C-W>+", { desc = "Increase window height" })

-- Easier scope selection
vim.keymap.set("x", "<right>", "an", { remap = true, desc = "Select more" })
vim.keymap.set("x", "<left>", "in", { remap = true, desc = "Select less" })

-- Quickfix
-- vim.keymap.set("n", "<down>", "<cmd>cnext<CR>", { desc = "Quickfix next", silent = true })
-- vim.keymap.set("n", "<up>", "<cmd>cprev<CR>", { desc = "Quickfix previous", silent = true })

-- Locklist
-- vim.keymap.set("n", "<left>", "<cmd>lnext<CR>", { desc = "Locklist next", silent = true })
-- vim.keymap.set("n", "<right>", "<cmd>lprev<CR>", { desc = "Locklist previous", silent = true })

vim.keymap.set("n", "<C-s>", ":!tmux neww tmux-sessionizer<CR>", { desc = "Run tmux-sessionizer", silent = true })


--------------------------------------------------------------------------------
-- Leader keymaps
--------------------------------------------------------------------------------

-- vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" }) -- TODO: Move

-- vim.keymap.set("n", "<leader>su", ":Undotree<CR>", { desc = "Toggle builtin Undotree" }) -- TODO: move

-- vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- remane all instances of word under cursor
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
-- vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file (refresh Lua configurations)" })
-- vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
