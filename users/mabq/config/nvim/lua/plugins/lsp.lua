return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      -- Auto-completion configuration -----------------------------------------

      "saghen/blink.cmp", -- completion plugin with support for LSPs, cmdline, signature help and snippets
      version = "1.*", -- use a release tag to download pre-built binaries
      dependencies = {
        -- {
        --   "L3MON4D3/LuaSnip", -- Snippet engine
        --   version = "v2.*",
        --   build = "make install_jsregexp", -- Install jsregexp (optional)
        --   config = function()
        --     require("luasnip.loaders.from_vscode").lazy_load() -- load friendly-snippets
        --   end,
        -- },
        { "rafamadriz/friendly-snippets" }, -- snippet source
        { "moyiz/blink-emoji.nvim" }, -- emoji source
        {
          "folke/lazydev.nvim", -- configures LuaLS to support auto-completion and type checking while editing your Neovim configuration.
          dependencies = {
            "Bilal2453/luvit-meta", -- autocompletion and type information for Neovim's `vim.uv` API, see `:h luvref`
            lazy = true,
          },
          ft = "lua", -- lazy-load on filetype
          cmd = "LazyDev",
          opts = {
            library = {
              { path = "luvit-meta/library", words = { "vim%.uv" } }, -- Load luvit types when the `vim.uv` word is found
              -- { path = "/usr/share/awesome/lib/", words = { "awesome" } },
              { path = "LazyVim", words = { "LazyVim" } },
              -- { path = "snacks.nvim", words = { "Snacks" } },
              { path = "lazy.nvim", words = { "LazyVim" } },
              { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
            },
          },
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
      opts = {
        keymap = {
          preset = "default", -- use same built-in completions
          --  <c-space>                   Open menu or open docs if already open
          --  <c-e>                       Hide menu
          --  <c-y>                       Accept
          --  <tab>/<s-tab>               Move to right/left of your snippet expansion
          --  <c-n>/<c-p> or <up>/<down>  Select next/previous item
          --  <c-k>                       Toggle signature help
          -- See :h blink-cmp-config-keymap for defining your own keymap
        },
        appearance = {
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono", -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        },
        completion = {
          documentation = {
            auto_show = false, -- only show the documentation popup when manually triggered
          },
        },
        sources = {
          -- Default list of enabled providers defined so that you can extend it
          -- elsewhere in your config, without redefining it, due to `opts_extend`
          default = { "lazydev", "lsp", "path", "snippets", "buffer", "emoji" },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100, -- make lazydev top priority (`:h blink.cmp`)
            },
            emoji = {
              name = "Emoji",
              module = "blink-emoji",
            },
          },
        },
        -- (Default) Rust fuzzy matcher for typo resistance and significantly
        -- better performance You may use a lua implementation instead by using
        -- `implementation = "lua"` or fallback to the lua implementation, when
        -- the Rust fuzzy matcher is not available, by using `implementation =
        -- "prefer_rust"`
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
  },

  -- LSP configuration -------------------------------------------------------

  config = function()
    -- Customizations to language servers
    --   These will be merged with the ones provided by nvim-lspconfig
    --   See `:h lspconfig-all`
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            format = { enable = false }, -- formatting is done by stylua
          },
        },
      },
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
