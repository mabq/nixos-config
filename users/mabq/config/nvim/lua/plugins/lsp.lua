return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- Lazydev configures Lua LSP for your Neovim config, runtime and
        -- plugins used for completion, annotations and signatures of Neovim
        -- apis.
        "folke/lazydev.nvim",
        ft = "lua", -- lazy-load on filetype
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } }, -- load luvit types when the `vim.uv` word is found
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      {
        -- Autocompletion and type information for Neovim's `vim.uv` API
        "Bilal2453/luvit-meta",
        lazy = true,
      },
      -- { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", },

      -- {
      --   "dmmulroy/tsc.nvim",
      --   config = function()
      --     require("tsc").setup {
      --       run_as_monorepo = true,
      --     }
      --   end,
      -- },

      -- {
      --   "pmizio/typescript-tools.nvim",
      --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      -- },

      --  Schema is a file that describes the shape of another file — what
      --  fields exist, what types they are, which are required, what the valid
      --  values are. SchemaStore is simply a central place where thousands of
      --  these descriptions are maintained for common tools.
      "b0o/SchemaStore.nvim",
    },

    config = function()
      local servers = {
        lua_ls = true,
        -- lua_ls = {
          -- cmd = { "lua-language-server" },
          -- server_capabilities = {
          --   semanticTokensProvider = vim.NIL,
          -- },
          -- on_init = function(client)
          --   if client.workspace_folders then
          --     local path = client.workspace_folders[1].name
          --     if
          --       path ~= vim.fn.stdpath('config')
          --       and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
          --     then
          --       return
          --     end
          --   end
          --
          --   client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          --     runtime = {
          --       -- Tell the language server which version of Lua you're using (most
          --       -- likely LuaJIT in the case of Neovim)
          --       version = 'LuaJIT',
          --       -- Tell the language server how to find Lua modules same way as Neovim
          --       -- (see `:h lua-module-load`)
          --       path = {
          --         'lua/?.lua',
          --         'lua/?/init.lua',
          --       },
          --     },
          --     -- Make the server aware of Neovim runtime files
          --     workspace = {
          --       checkThirdParty = false,
          --       library = {
          --         vim.env.VIMRUNTIME,
          --         -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          --         vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
          --       },
          --       -- Or pull in all of 'runtimepath'.
          --       -- NOTE: this is a lot slower and will cause issues when working on
          --       -- your own configuration.
          --       -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          --       -- library = vim.api.nvim_get_runtime_file('', true),
          --     },
          --   })
          -- end,
        -- },
      }

      --------------------------------------------------------------------------

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      -- Set global capabilities for all LSP servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      --------------------------------------------------------------------------

      -- Configure and enable each LSP server
      for name, config in pairs(servers) do
        if config == true then
          vim.lsp.config(name, {})
        else
          vim.lsp.config(name, config)
        end

        vim.lsp.enable(name)
      end

      --------------------------------------------------------------------------

      -- require("custom.autoformat").setup()

      --------------------------------------------------------------------------

      -- require("lsp_lines").setup()

      vim.diagnostic.config({
        virtual_text = true, -- avoid pointless duplication
        virtual_lines = false,
      })

      -- vim.keymap.set( "", "<Leader>tv", require("lsp_lines").toggle, { desc = "Virtual lines (LSP)" })

      vim.keymap.set("", "<leader>tv", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })

      --------------------------------------------------------------------------

      -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspAttach', { clear = true }), -- clear to avoid duplication

        callback = function()
          -- local bufnr = args.buf
          -- local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          -- local settings = servers[client.name]
          -- if type(settings) ~= "table" then
          --   settings = {}
          -- end

          local builtin = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          -- We use the same keymaps used by Neovim by default, see `:h lsp-defaults`.

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
          -- vim.keymap.set('n', 'grd', builtins.lsp_definitions, { buffer = buf, desc = 'Definition' })

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })

          -- Find references for the word under your cursor.
          --  You can move through references without changin buffers, filter results down
          --  and send those to quickfix.
          -- vim.keymap.set('n', 'grr', builtins.lsp_references, { buffer = buf, desc = 'References' })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0, desc = 'References' })

          -- Jump to the implementation of the word under your cursor.
          --  Opens Telescope only if there is more than one result.
          --  Useful when your language has ways of declaring types without an actual implementation.
          -- vim.keymap.set('n', 'gri', builtins.lsp_implementations, { buffer = buf, desc = 'Implementation' })

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          -- vim.keymap.set('n', 'gO', builtins.lsp_document_symbols, { buffer = 0, desc = 'Open Document Symbols' })
          -- vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = 0 })
          -- vim.keymap.set("n", "<space>ww", function()
          --   builtin.diagnostics { root_dir = true }
          -- end, { buffer = 0 })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          -- vim.keymap.set('n', 'gW', builtins.lsp_dynamic_workspace_symbols, { buffer = 0, desc = 'Open Workspace Symbols' })

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          -- vim.keymap.set('n', 'grt', builtins.lsp_type_definitions, { buffer = buf, desc = 'Type Definition' })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })

          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

          -- local filetype = vim.bo[bufnr].filetype
          -- if disable_semantic_tokens[filetype] then
          --   client.server_capabilities.semanticTokensProvider = nil
          -- end

          -- Override server capabilities
          -- if settings.server_capabilities then
          --   for k, v in pairs(settings.server_capabilities) do
          --     if v == vim.NIL then
          --       ---@diagnostic disable-next-line: cast-local-type
          --       v = nil
          --     end
          --
          --     client.server_capabilities[k] = v
          --   end
          -- end
        end,

      })

      --------------------------------------------------------------------------

    end
  },
}

--[[

`:h lsp-quickstart`

  Explains the steps required to setup a language server.

`:h lsp-defaults`
  Default features and keymaps set by Neovim for LSP usage and how you can
  disable them.

`:h lsp-commands`
  Commands to enable, disable, restart and stop language servers.

`:h lsp-new-config`
  Create lsp configurations.

`:h lsp-config-merge`
  Where Neovim looks for LSP configurations, in what order and how they are
  merged.

`:h lsp-attach`
  How to create autocommands to attach and enable LSP features based on the
  capabilities of the language server.

`:h lsp-faq`
  Files in "after/lsp/" are loaded after those in "nvim/lsp/", so your settings
  will take precedence over the defaults provided by nvim-lspconfig.

`:`

--------------------------------------------------------------------------------

LSP is just a protocol that defines how a client and a server communicate.

The client (Neovim)
-------------------

  Neovim acts as the client and provides all the functionality necessary to
  interchange information with the language servers installed on the system.

  This file instructs LSP to attach a language server to the current buffer
  based on its filetype.

  Use;
    `:h lsp` to learn about LSP in Neovim.
    `:checkhealth lsp` to verify the status of LSP.

  Helpful videos:
    [Understanding Neovim #7 - Language Server Protocol](https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7).
    [Common pitfalls](https://youtu.be/UVcC5ifbXL8?si=LJ8-DBjCPvQ3DZmr&t=439)

Language servers
----------------

  These are third party tools built to understand a particular language. For
  example: gopls (Go), lua_ls (Lua), rust_analyzer (Rust), etc.

  These tools are separate packages that you need to install on your system.
  Mason is a tools that can help you install these packages from Neovim but I
  prefer to manage all packages with the system package manager.

  Capabilities:

    Not all language servers provide the same capabilities, but most support
    the critical ones, like:
      Go to definition
      Go to references
      Rename a variable

    Use:
      `:=vim.lsp.protocol.make_client_capabilities()` to list Neovim capabilities.
      `:=vim.lsp.get_clients()[1].server_capabilities` to list capabilities of the attached LSP.

  Configuration:

    Each language server is different. Check their respective websites to see
    what options are available.
    For example, configuration options for Lua are defined here:
      https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L667

Nvim-lspconfig
--------------

    The nvim-lspconfig plugin provides default configurations for most
    language servers.

    When you install the plugin, `vim.lsp.config` automatically finds them and
    merges them with any local `lsp/*.lua` configs defined by you or a plugin.

    You can check the plugin configurations for any language server in:
      `h lspconfig-all`
      https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

--]]






--  This function gets run when an LSP attaches to a particular buffer. That is
--   to say, every time a new file is opened that is associated with an lsp (for
--   example, opening `main.rs` is associated with `rust_analyzer`) this
--   function will be executed to configure the current buffer

-- --------------------------------------------------------------------------------
-- -- Diagnostics config
-- --------------------------------------------------------------------------------
-- vim.diagnostic.config {
--   update_in_insert = false,
--   severity_sort = true,
--   float = { border = 'rounded', source = 'if_many' },
--   underline = { severity = { min = vim.diagnostic.severity.WARN } },
--
--   -- Can switch between these as you prefer
--   virtual_text = true, -- Text shows up at the end of the line
--   virtual_lines = false, -- Text shows up underneath the line, with virtual lines
--
--   -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
--   jump = {
--     on_jump = function(_, bufnr)
--       vim.diagnostic.open_float {
--         bufnr = bufnr,
--         scope = 'cursor',
--         focus = false,
--       }
--     end,
--   },
-- }
--
-- -- vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Diagnostics loclist' })
--
-- --------------------------------------------------------------------------------
-- -- Autocommands
-- --------------------------------------------------------------------------------
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }), -- clear to avoid duplications
--   callback = function(event)
--     local buf = event.buf
--
--     -- We use the same keymaps used by Neovim by default, see `:h lsp-defaults`.
--
--     -- Rename the variable under your cursor.
--     --  Most Language Servers support renaming across files, etc.
--     vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = buf, desc = 'Rename' })
--
--     -- Execute a code action, usually your cursor needs to be on top of an error
--     -- or a suggestion from your LSP for this to activate.
--     vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { buffer = buf, desc = 'Goto Code Action' })
--
--     -- This is not Goto Definition, this is Goto Declaration.
--     --  For example, in C this would take you to the header.
--     vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })
--
--     -- Enable the following if you want to highlight references of the word
--     -- under your cursor when your cursor rests there for a little while.
--     --  See `:help CursorHold` for information about when this is executed
--     --  `:h lsp-attach`
--     local client = vim.lsp.get_client_by_id(event.data.client_id)
--     -- if client and client:supports_method('textDocument/documentHighlight', event.buf) then
--     --   local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
--     --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--     --     buffer = event.buf,
--     --     group = highlight_augroup,
--     --     callback = vim.lsp.buf.document_highlight,
--     --   })
--     --
--     --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--     --     buffer = event.buf,
--     --     group = highlight_augroup,
--     --     callback = vim.lsp.buf.clear_references,
--     --   })
--     --
--     --   -- Clear the highlights when you move the cursor out.
--     --   vim.api.nvim_create_autocmd('LspDetach', {
--     --     group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
--     --     callback = function(event2)
--     --       vim.lsp.buf.clear_references()
--     --       vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
--     --     end,
--     --   })
--     -- end
--
--     -- Create a keymap to toggle inlay hints, if the language server supports them.
--     -- Inlay hints are virtual text, not real text.
--     if client and client:supports_method('textDocument/inlayHint', event.buf) then
--       vim.keymap.set('n', '<leader>th', function()
--         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
--       end, { buffer = buf, desc = 'Inlay Hints (LSP)' })
--     end
--   end,
-- })

