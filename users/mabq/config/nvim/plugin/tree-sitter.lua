-------------------------------------------------------------------------------
--
-- Tree-sitter is a parser generator tool and an incremental parsing library.
--
-- It can build a concrete syntax tree for a source file and efficiently update
-- the syntax tree as the source file is edited.
--   https://tree-sitter.github.io/tree-sitter/index.html
--
-- Tree-sitter rules are called "grammars" and are written in JavaScript. The
-- compiled results of these grammars are called "parsers" and are what the
-- tree-sitter library uses to parse code.
--
-- Out-of-the-box Neovim includes the tree-sitter library for incremental
-- parsing of buffers, plus a few parsers.
--   See `:h treesitter-parsers`
--
-- To install additional parsers we use the `nvim-treesitter` plugin, which
-- requires `tar`, `curl` and the `tree-sitter-cli` to be installed on the system.
--   See `:h nvim-treesitter-intro`
--   https://github.com/nvim-treesitter/nvim-treesitter
--
-- Parsers, queries and related files are stored in `~/.local/share/nvim/site/`.
--
-- The main interface for Nvim's tree-sitter integration is the `vim.treesitter`
-- Lua module.
--   See `:h lua-treesitter`
--   E.g. `:lua vim.treesitter.inspect_tree()`, which is the same as `:InspectTree`.
--
-------------------------------------------------------------------------------

-- Install and configure the plugin
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } })

-- Automatically install these basic parsers
--   Install directory defaults to `stdpath('data')/site` (to check where that path points to use `:=vim.fn.stdpath 'data'` ).
require("nvim-treesitter").install({
	"bash",
	"c",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
})

local function treesitter_try_attach(buf, language)
	-- Check if a parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end

	-- Enable syntax highlighting and other treesitter features.
	vim.treesitter.start(buf, language)

	-- Enable tree-sitter based folds.
	--   For more info on folds see `:help folds`.
	vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo.foldmethod = "expr"
	vim.wo.foldenable = false -- Open all by default, toggle with `zi`.

	-- Enable tree-sitter based indentation.
	--   Check if treesitter indentation is available for this language.
	local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
	--   The `indentexpr` option defines a function that returns the correct
	--   indentation for the current line whenever you press `=`, Enter or any
	--   auto-indent action triggers. When set it overrules the `smartindent` option.
	--   In case there is no indent query, the `indentexpr` will fallback
	--   to the vim's built in one.
	if has_indent_query then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype)
		if not language then
			return
		end

		local installed_parsers = require("nvim-treesitter").get_installed("parsers")

		if vim.tbl_contains(installed_parsers, language) then
			-- Enable the parser if it is already installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
			require("nvim-treesitter").install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			-- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end,
})
