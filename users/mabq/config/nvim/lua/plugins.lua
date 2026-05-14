--------------------------------------------------------------------------------

-- STANDARD PLUGINS (builtin)
--   `:h standard-plugin-list`

-- Load builtin undotree
vim.cmd.packadd("nvim.undotree")

--------------------------------------------------------------------------------

-- EXTERNAL PLUGINS
--   `:h vim.pack`
--   `:h vim.pack-examples`
--   https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
--
--   To inspect plugin state and pending updates, run
--     :lua vim.pack.update(nil, { offline = true })
--
--   To update plugins, run
--     :lua vim.pack.update()

vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- required by many plugins

	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },

	{ src = "https://github.com/folke/tokyonight.nvim" },
})

--------------------------------------------------------------------------------

-- TREESITTER
--
--   Tree-sitter core:
--
--     Tree-sitter is a parser generator tool and an incremental parsing library.
--
--     It can build a concrete syntax tree for a source file and efficiently
--     update the syntax tree as the source file is edited.
--       [Tree-sitter](https://tree-sitter.github.io/tree-sitter/index.html)
--
--     Tree-sitter analizes syntax (not semantics) and it focuses only a single
--     file (not a project). Its main feature is syntax highlighting, but it also
--     provides smart code folding, automatic indentation, syntax-aware text
--     objects and navigation.
--       `:h lsp-vs-treesitter`
--       [Treesitter basics and installation](https://www.youtube.com/watch?v=MpnjYb-t12A&list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM&index=6)

--     The tree-sitter parsing library is built into Neovim by default, but it
--     only includes just a few language parsers. We use the nvim-treesitter
--     plugin to automatically install additional language parsers.
--       `:h treesitter-parsers`
--
--     Whenever you see `vim.treesitter` below it has to do with functionality
--     provided by the core integration of tree-sitter in Neovim.
--       `:h lua-treesitter`
--       `:lua vim.treesitter.inspect_tree()` same as `:InspectTree`

--   Nvim-treesitter (the plugin):
--
--     Nvim-treesitter provides functionalities for managing treesitter parsers
--     and compatible queries for core features (highlighting, injections, folds,
--     indents).
--
--     Tree-sitter rules are called "grammars" and are written in JavaScript,
--     these are compiled locally by the `tree-sitter-cli` tool to produce the
--     final parsers used to parse the code. You must install the following
--     tools with your package manager:
--
--       `curl`               To get files from the internet
--       `tar`                To decompress any downloaded files
--       `tree-sitter-cli`    To generate the parsers from the downloaded files
--                            In nix the package is called "tree-sitter"
--
--     Installed parsers are stored by default in `stdpath('data')/site`.
--     Use `:= vim.fn.stdpath 'data'` to check where it points to.
--
--     You can check the features provided by each installed parser with
--     `:checkhealth nvim-treesitter`:
--
--       [H]ighlights         Improved syntax coloring.
--                            `:Inspect` - shows all currently applied highlights for text under cursor.
--                            `:InspectTree` - shows the AST
--       [F]olds              Allows code folding based on the tree structure.
--       [I]ndents            Provides logic for auto-indentation.
--                            When you press Enter or use `=`.
--       [L]ocals             Defines the scope of variables and blocks (used for "inner" and "outer").
--       In[J]ections         Allows for languages nested inside others (e.g., CSS inside HTML).
--
--     Whenever you see `require('nvim-treesitter')` below it has to do with
--     functionality provided by the plugin.
--       `:h nvim-treesitter-commands`
--
--     For more information see:
--       [Nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
--       `:h nvim-treesitter-intro`
--       `:h nvim-treesitter-api`

-- Install and require the plugin
--   The 'master' branch is now deprecated.
--   The `main` branch is a total rewrite for Nvim 0.12 and later.
local nvim_treesitter = require("nvim-treesitter")

-- Install the following basic parsers by default
--   Parsers for other filetypes will try to be installed automatically when opening those filetypes.
nvim_treesitter.install({
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

-- Enable tree-sitter features function
local function treesitter_try_attach(buf, language)
	-- Check parser is available before enabling tree-sitter features
	if not vim.treesitter.language.add(language) then
		return
	end
	-- Highlighting
	--   https://github.com/nvim-treesitter/nvim-treesitter#highlighting
	vim.treesitter.start(buf, language)
	-- Folds
	--   See `:h folds` and `:h fold-commands`
	--   https://github.com/nvim-treesitter/nvim-treesitter#folds
	vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo.foldmethod = "expr"
	vim.opt.foldenable = false -- start without folds (toggle with `zi`)
	-- Indentation
	--   The `indentexpr` option defines a function that returns the correct
	--   indentation for the current line whenever you press `=`, `Enter` or any
	--   auto-indent action triggers.
	--   When this option is set it overrides the `smartindent` option.
	local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil
	if has_indent_query then
		-- https://github.com/nvim-treesitter/nvim-treesitter#indentation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
	-- Injections
	--   Injections are used for multi-language documents. No setup is needed.
	--   See `:h treesitter-language-injections`
	-- Locals
	--   These queries can be used to look up definitions and references to
	--   identifiers in a given scope. They are not used in this plugin and are
	--   provided for (limited) backward compatibility.
end

-- Tree-sitter autocommands --

-- Use a group to clear and avoid duplication
local group = vim.api.nvim_create_augroup("user-nvim-treesitter", { clear = true })

-- Automatically update parsers whenever the plugin updates
vim.api.nvim_create_autocmd("PackChanged", {
	group = group,
	pattern = "nvim-treesitter", -- only run the callback when this specific plugin changes
	callback = function(ev)
		local kind = ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end

		if not ev.data.active then
			vim.cmd.packadd("nvim-treesitter") -- the plugin may have just been installed or updated but not loaded yet
		end

		vim.cmd("TSUpdate") -- update all parsers
	end,
})

-- Try to attach a tree-sitter parser to any buffer with a filetype
local available_parsers = nvim_treesitter.get_available() -- provides a list of all the parsers supported by nvim-treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		local buf, filetype = args.buf, args.match

		local language = vim.treesitter.language.get_lang(filetype) -- returns the language name to be used when loading a parser for the given filetype
		if not language then
			return
		end

		local installed_parsers = nvim_treesitter.get_installed("parsers") -- provides a list of parsers currently installed

		if vim.tbl_contains(installed_parsers, language) then
			-- Enable the parser if it is already installed
			treesitter_try_attach(buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			-- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
			nvim_treesitter.install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			-- Try to enable tree-sitter features in case the parser exists but is not available from `nvim-treesitter`
			treesitter_try_attach(buf, language)
		end
	end,
})

--------------------------------------------------------------------------------

-- LSP
--   Langugage servers must be installed with home-manager
--   Each language server is configured and loaded in `/after/ftplugin/<language>.lua`
--   https://github.com/neovim/nvim-lspconfig#quickstart
--   `:h lsp`
