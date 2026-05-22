--  This function gets run when an LSP attaches to a particular buffer. That is
--   to say, every time a new file is opened that is associated with an lsp (for
--   example, opening `main.rs` is associated with `rust_analyzer`) this
--   function will be executed to configure the current buffer

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }), -- clear to avoid duplications
  callback = function(event)
    local buf = event.buf

    -- We use the same keymaps used by Neovim by default, see `:h lsp-defaults`.

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = buf, desc = 'Rename' })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({'n', 'x'}, 'gra', vim.lsp.buf.code_action, { buffer = buf, desc = 'Goto Code Action' })

    -- This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })

    -- Enable the following if you want to highlight references of the word
    -- under your cursor when your cursor rests there for a little while.
    --  See `:help CursorHold` for information about when this is executed
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- if client and client:supports_method('textDocument/documentHighlight', event.buf) then
    --   local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    --     buffer = event.buf,
    --     group = highlight_augroup,
    --     callback = vim.lsp.buf.document_highlight,
    --   })
    --
    --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    --     buffer = event.buf,
    --     group = highlight_augroup,
    --     callback = vim.lsp.buf.clear_references,
    --   })
    --
    --   -- Clear the highlights when you move the cursor out.
    --   vim.api.nvim_create_autocmd('LspDetach', {
    --     group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
    --     callback = function(event2)
    --       vim.lsp.buf.clear_references()
    --       vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
    --     end,
    --   })
    -- end

    -- Create a keymap to toggle inlay hints, if the language server supports them.
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled)
      end, { buffer = buf, desc = 'LSP Inline Hints' })
    end
  end,
})

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local servers = {
        lua_ls = {},
        bashls = {},
      }

      for name, setup in pairs(servers) do
        require('lspconfig')[name].setup(setup)
      end
    end,
  },
  -- {
  --   "j-hui/fidget.nvim", -- Useful status updates for LSP
  --   opts = {},
  -- },

  -- {
  -- JavaScript / TypeScript: Replaced `typescript-language-server` (`ts_ls`)
  -- with 'pmizio/typescript-tools.nvim'. `ts_ls` does not support
  -- Styled-Components and is supposed to be awefully slow on big projects.
  -- `typescript-tools` has more commands than the ones binded to keymaps, use
  -- `:TSTools<Tab>` to see them.
  --
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {
  --     tsserver_plugins = { '@styled/typescript-styled-plugin' },
  --   },
  -- },
  ------------------------------------------------------------------------------
  {
    'folke/lazydev.nvim', -- lsp for Neovim configuration
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}

--[[

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

    The nvim-lspconfig plugin provides a set of default configurations for most
    language servers available. You can use those or configure some language
    servers manually.
      https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

--]]
