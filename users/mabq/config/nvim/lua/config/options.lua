vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.guicursor = ""

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2 -- see GuessIndent plugin
vim.opt.shiftwidth = 0 -- do not change!
vim.opt.softtabstop = -1 -- do not change!
vim.opt.expandtab = true
vim.opt.shiftround = true

vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.breakindent = true -- preserve indentation in wrapped text
vim.opt.linebreak = true -- do not break words when wrapping

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") -- add `@` as a valid filename character

vim.opt.updatetime = 250

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

vim.opt.spelllang = { "en", "es" }

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Notes:
--   [Configure Neovim Options](https://www.youtube.com/watch?v=F1CQVXA5gf0&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=5)
--   [Options and variables explained](https://www.youtube.com/watch?v=Cp0iap9u29c&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=6)
--   `:help opt`
--   `:options` - interactive list
