-- `:help lua-guide-options`
-- `:help vim.o`
-- `:option-list`
-- Configure Neovim Options (TJ DeVries) - https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5
-- Options and variables explained (TJ DeVries) - https://www.youtube.com/watch?v=Cp0iap9u29c&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=6

vim.o.guicursor = ""

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.tabstop = 2 -- see GuessIndent plugin
vim.o.shiftwidth = 0 -- do not change!
vim.o.softtabstop = -1 -- do not change!
vim.o.expandtab = true
vim.o.shiftround = true

vim.o.smartindent = true

vim.o.wrap = false
vim.o.breakindent = true -- preserve indentation in wrapped text
vim.o.linebreak = true -- do not break words when wrapping

vim.o.swapfile = false
vim.o.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.inccommand = 'split' -- preview substitutions live, as you type!

vim.o.termguicolors = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.opt.isfname:append("@-@") -- add `@` as a valid filename character

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.colorcolumn = "80"
vim.o.cursorline = true

vim.opt.spelllang = { "en", "es" }

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
--  instead raise a dialog asking if you wish to save the current file(s)
--  See `:help 'confirm'`
vim.o.confirm = true
