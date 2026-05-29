return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- Lazydev teached the Lua LSP about Neovim plugins only when needed
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
        -- Autocompletion and type information for Neovim's `vim.uv` API, see `:h luvref`
        "Bilal2453/luvit-meta",
        lazy = true,
      },
      -- { "b0o/SchemaStore.nvim", },
      -- { "j-hui/fidget.nvim", opts = {} },
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
    },

    config = function()

      -- local capabilities = nil
      -- if pcall(require, "cmp_nvim_lsp") then
      --   capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- end

      -- Set global capabilities for all LSP servers
      -- vim.lsp.config("*", {
      --   capabilities = capabilities,
      -- })

      --------------------------------------------------------------------------

      local servers = {
        lua_ls = true,
      }

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

      -- Add keymaps to the buffer when an LSP is attached
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }), -- clear to avoid duplication
        callback = function(event)
          local bufnr = event.buf
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "Must have valid client (LSP)")
          local telescope = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Customize default lsp keymaps (see `:h lsp-defaults`) -------------
          --   K is not listed in the documentation but it works

          --   Use telescope to show found references
          vim.keymap.set("n", "grr", telescope.lsp_references, { buffer = bufnr, desc = 'Go to References (LSP)' })

          --   Use telescope to show symbols of the current document
          vim.keymap.set('n', 'gO', telescope.lsp_document_symbols, { buffer = bufnr, desc = 'Open Document Symbols (LSP)' })

          --

          -- Go to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition (LSP)" })

          -- Go to Declaration.
          --  For example, in C this would take you to the header.
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration (LSP)" })

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set('n', 'gW', telescope.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = 'Open Workspace Symbols (LSP)' })

          -- Create a keymap to toggle inlay hints (if the language server supports them)
          --  This may be unwanted, since they displace some of your code
          if client and client:supports_method('textDocument/inlayHint', bufnr) then
            vim.keymap.set('n', '<leader>ti', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } )
            end, { buffer = bufnr, desc = 'Inlay Hints (LSP)' })
          end

          ---

          -- local settings = servers[client.name]
          -- if type(settings) ~= "table" then
          --   settings = {}
          -- end

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

    end
  },
}

--[[

Check LSP status:
  `:checkhealth lsp` to verify the status of LSP.

Steps required to setup a language server:
  `:h lsp-quickstart`.

Attributes accepted by `vim.lsp.config()`:
  `:h vim.lsp.Config`
  `:h vim.lsp.ClientConfig`

Check capabilities:
  `:=vim.lsp.protocol.make_client_capabilities()` - Neovim capabilities
  `:=vim.lsp.get_clients()[1].server_capabilities` - attached LSP capabilities

Where lsp configs can be stored and how they are merged:
  `:h lsp-new-config`
  `:h lsp-config-merge`

Default features and keymaps set by Neovim for LSP usage and how you can disable them:
  `:h lsp-defaults`

Commands to enable, disable, restart and stop language servers:
  `:h lsp-commands`

How to create autocommands to attach a language server to the buffer:
  `:h lsp-attach`

LSP frequently asked questions:
  `:h lsp-faq`

Helpful videos:
  [Understanding Neovim #7 - Language Server Protocol](https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7).
  [Common pitfalls](https://youtu.be/UVcC5ifbXL8?si=LJ8-DBjCPvQ3DZmr&t=439)

--]]
