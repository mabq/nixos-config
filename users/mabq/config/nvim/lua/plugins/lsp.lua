return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Configure LSPs:
      --   These customized configurations will be merged with the ones
      --   provided by nvim-lspconfig. Pass an emtpy table `{}` to use the
      --   default config.
      --
      --   Use `:h lspconfig-all` to search the configuration of the desired
      --   LSP.
      --
      --   Make sure the command described in the configuration is available in
      --   the system with `:echo executable(<command>)`. For example, the
      --   `lua_ls` configuration expects to find the `lua-language-server`
      --   command.
      local servers = {
        -- Bash (bashls requires `bash-language-server`)
        bashls = {},

        -- Lua (lua_ls requires `lua-language-server`)
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath "config"
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
              then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                  "lua/?.lua",
                  "lua/?/init.lua",
                },
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                  vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                },
                -- Or pull in all of 'runtimepath'.
                -- NOTE: this is a lot slower and will cause issues when working on
                -- your own configuration.
                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                -- library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        },

        -- Nix (nixd required `nixd`)
        nixd = {},
      }

      -- Configure and enable
      for name, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities) -- add LSP capabilities provided by Blink
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- Add keymaps to the buffer when an LSP is attached
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }), -- clear to avoid duplication
        callback = function(event)
          local bufnr = event.buf
          local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "Must have valid client (LSP)")
          local telescope = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Customize default lsp keymaps (see `:h lsp-defaults`) -------------
          --   K is not listed in the documentation but it works

          --   Use telescope to show found references
          vim.keymap.set("n", "grr", telescope.lsp_references, { buffer = bufnr, desc = "Go to References (LSP)" })

          -- Go to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition (LSP)" })

          -- Go to Declaration.
          --  For example, in C this would take you to the header.
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration (LSP)" })

          --   Use telescope to show symbols of the current document
          vim.keymap.set(
            "n",
            "gO",
            telescope.lsp_document_symbols,
            { buffer = bufnr, desc = "Open Document Symbols (LSP)" }
          )

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          vim.keymap.set(
            "n",
            "gW",
            telescope.lsp_dynamic_workspace_symbols,
            { buffer = bufnr, desc = "Open Workspace Symbols (LSP)" }
          )

          -- Create a keymap to toggle inlay hints (if the language server supports them)
          --  This may be unwanted, since they displace some of your code
          if client and client:supports_method("textDocument/inlayHint", bufnr) then
            vim.keymap.set("n", "<leader>ti", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            end, { buffer = bufnr, desc = "Inlay Hints (LSP)" })
          end
        end,
      })
    end,
  },

  --  Schema is a file that describes the shape of another file — what
  --  fields exist, what types they are, which are required, what the valid
  --  values are. SchemaStore is simply a central place where thousands of
  --  these descriptions are maintained for common tools.
  -- { "b0o/SchemaStore.nvim", },
  --
  -- { "j-hui/fidget.nvim", opts = {} },
  --
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
