vim.o.swapfile = false -- disable swap files

vim.o.undofile = true -- make undo/redo work even after closing the file, see `:h undo-persistence`
vim.o.undodir = vim.fn.stdpath "state" .. "/undo" -- set the directory path for undo file

vim.opt.shada = { "'10", "<0", "s10", "h" } -- better settings for shada files

vim.o.ignorecase = true -- can be overruled by using `\c` or `\C` in the pattern
vim.o.smartcase = true -- case sensitive if the search pattern contains upper case characters

vim.o.inccommand = "split" -- preview substitutions live, as you type!

vim.o.wrap = false -- do not wrap lines by default
vim.o.linebreak = true -- do not break words when wrapping
vim.o.breakindent = true -- preserve indentation in wrapped text

-- vim.opt.formatoptions:remove("o") -- no automatic comment continuation

vim.o.list = true -- show <Tab> and <EOL>
vim.o.listchars = "tab:· ,trail:·,nbsp:␣" -- how to display these whitespace characters

vim.o.number = true
vim.o.relativenumber = true

vim.o.guicursor = "" -- always show block cursor
vim.o.signcolumn = "yes" -- keep signcolumn on by default

vim.o.showmode = false -- do not show edit mode
vim.o.scrolloff = 4 -- minimal number of screen lines to keep above and below the cursor
vim.o.confirm = true -- raise a dialog when trying to quit an unsaved buffer

-- vim.o.colorcolumn = "80" -- colums to highlight

vim.o.splitbelow = true -- horizontal splits to the bottom
vim.o.splitright = true -- vertical splits to the right

vim.o.mouse = "a" -- enable all mouse modes, can be useful for resizing splits

vim.o.spelllang = "en_us,es_ec"

vim.o.updatetime = 250 -- decrease update time

--[[

Help:
 `:h vim.o`
 `:h option-list`
 `:h lua-guide-options`

Configure Neovim Options:
  https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5

Options and variables explained:
  https://www.youtube.com/watch?v=Cp0iap9u29c&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=6

--]]

