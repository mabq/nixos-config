-- IMPORTANT: External packages required!
--   tree-sitter-cli
--   curl
--   tar

--------------------------------------------------------------------------------
-- Helper function
--------------------------------------------------------------------------------

-- This function determines which tree-sitter features we want to enable. Read
-- notes at the bottom.
local function try_attach(buf, language)
  if not vim.treesitter.language.add(language) then
    return -- no parser available, exit
  end

  -- Highlighting
  vim.treesitter.start(buf, language)

  -- Folds
  -- vim.wo.foldmethod = "expr"
  -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  -- Indentation
  local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
  if has_indent_query then
    -- 'indentexpr' takes precedence over 'smartindent'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

--------------------------------------------------------------------------------
-- Nvim-treesitter
--------------------------------------------------------------------------------

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- executed when a plugin is installed or updated (required to build new parsers)
  branch = "main", -- the master branch is deprecated for neovim versions prior to 0.12
  config = function()
    local nvim_treesitter = require "nvim-treesitter"

    -- Install the following basic parsers by default (others will try to be
    -- installed automatically when opening those filetypes)
    nvim_treesitter.install {
      "bash",
      "diff",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "vim",
      "vimdoc",
    }

    -- This autocommand tries to attach/install a parser based on the buffer filetype
    local tsgroup = vim.api.nvim_create_augroup("nvim-treesitter", { clear = true }) -- clear to avoid duplication
    local available_parsers = nvim_treesitter.get_available() -- parsers supported by nvim-treesitter
    vim.api.nvim_create_autocmd("FileType", {
      group = tsgroup,
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return -- no language match for the current filetype, exit
        end

        local installed_parsers = nvim_treesitter.get_installed "parsers"

        if vim.tbl_contains(installed_parsers, language) then
          -- Language parser is installed, try to attach
          try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
          -- Language parser is not installed but is supported by nvim_treesitter, install and try to attach
          nvim_treesitter.install(language):await(function()
            try_attach(buf, language)
          end)
        else
          -- Language parser is not installed and is not supported by nvim_treesitter, try to attach in case it exist on the system
          try_attach(buf, language)
        end
      end,
    })
  end,
}

--------------------------------------------------------------------------------

--[[

Tree-sitter (the external tool):

  IMPORTANT!
    The `tree-sitter-cli` tool is required by the nvim-tressiter plugin to
    generate the language parsers.

  Tree-sitter is a parser generator tool and an incremental parsing library.
    https://tree-sitter.github.io/tree-sitter/

  Watch TJ's Tree-sitter explanation video:
    https://www.youtube.com/watch?v=MpnjYb-t12A&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=7


Neovim tree-sitter API (integration):

  The parsing library that creates/updates the ASTs is built into Neovim.

  You can use its methods to manually start/stop the tree-sitter engine:
    `:lua vim.treesitter.<method>`

  This files uses it to attach language parsers to the current buffer based
  on its filetype.
    `:h lua-treesitter`


Nvim-treesitter (the plugin):

  By default, Neovim includes only a couple of tree-sitter language parsers.
    `:h treesitter-parsers`

  This file installs the nvim-treesitter plugin and uses its methods to
  automatically install language parsers based on the filetype.
  Parsers are installed in `stdpath('data')/site` (use `:= vim.fn.stdpath 'data'`
  to check where it points to).

  The plugin also provides compatible queries for tree-sitter core features
  (highlighting, injections, folds, indents).

  For more information see:
    `:h nvim-treesitter-intro`
    `:h nvim-treesitter-api`
    `:h nvim-treesitter-commands`
    https://github.com/nvim-treesitter/nvim-treesitter#supported-features


Parser features:

  Not all language parsers support the same features. You can check which
  features are supported with `:checkhealth nvim-treesitter`:

    [H]ighlights          Improved syntax coloring.
                          See notes about highlight groups in "colorscheme.lua"
                          `:Inspect` - shows the highlight groups matching the word under cursor.
                          `:InspectTree` - shows the AST
    [F]olds               Allows code folding based on the tree structure.
                          Folding behaviour is controlled by the `foldmethod` option.
                          The default is 'manual'.
                          `:h foldmethod`, `:h folds` and `:h fold-commands`
    [I]ndents             Provides logic for auto-indentation.
                          This has nothing to do with formatting.
                          It manages the behaviour of the cursors while editing the buffer.
    [L]ocals              Defines the scope of variables and blocks (used for "inner" and "outer").
    In[J]ections          Allows for languages nested inside others (e.g., CSS inside HTML).


Tree-siiter vs. LSP:

  Tree-sitter focuses exclusively on syntax for one file. LSPs focus on
  semantics for the entire project.
    `:h lsp-vs-treesitter`

--]]
