-------------------------------------------------------------------------------
-- TREESITTER
--  Syntax higlighting, folds and indentation.
--
--  Neovim comes with the tree-sitter engine installed (it knows how to read
--  the ASTs and apply parsers to it) but you need to install the language
--  parsers that you need.
--
--  The nvim-treesitter plugin provides functionalities for managing treesitter
--  parsers and compatible queries for core features (highlighting, injections,
--  folds, indents). See `:help nvim-treesitter-intro`.

--   1. Functions for installing, updating, and removing tree-sitter language parsers.
--   2. A collection of queries for enabling tree-sitter features built into Neovim for these languages.
--   3. A staging ground for treesitter-based features considered for upstreaming to Neovim.
--
--  Nvim-treesitter requires:
--   1. `curl` and `tar` to download and decompress the downloaded parsers.
--      NixOS includes these by default.
--   2. The `treesitter-cli` tool to compile the downloaded parsers.
--      You need to install the Nix package called `tree-sitter`.
-------------------------------------------------------------------------------

-- Make Neovim fold lines based on tree-sitter
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = false  -- open all by default

-- NOTE: You can also specify a branch or a specific commit
vim.pack.add { { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' } }

-- Ensure basic parsers are installed
local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
require('nvim-treesitter').install(parsers)

local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then return end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  -- vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

  -- Enable treesitter based indentation
  if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if vim.tbl_contains(installed_parsers, language) then
      -- Enable the parser if it is already installed
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
      treesitter_try_attach(buf, language)
    end
  end,
})
