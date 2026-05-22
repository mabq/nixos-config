--  This function gets run when an LSP attaches to a particular buffer. That is
--   to say, every time a new file is opened that is associated with an lsp (for
--   example, opening `main.rs` is associated with `rust_analyzer`) this
--   function will be executed to configure the current buffer

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }), -- clear to avoid duplications
  callback = function(event)
    local buffer = event.buf

    -- We use the same keymaps used by Neovim by default, see `:h lsp-defaults`.

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { buffer = buffer, desc = 'Rename' })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set({'n', 'x'}, 'gra', vim.lsp.buf.code_action, { buffer = buffer, desc = 'Goto Code Action' })

    -- This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = buffer, desc = 'Goto Declaration' })

    -- Enable the following if you want to highlight references of the word
    -- under your cursor when your cursor rests there for a little while.
    --  See `:help CursorHold` for information about when this is executed
    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
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
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      vim.keymap.set('n', '<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled)
      end, { buffer = buffer, desc = 'LSP Inline Hints' })
    end
  end,
})

return {
  {
    enable = false,
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
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {
  --     tsserver_plugins = { '@styled/typescript-styled-plugin' },
  --   },
  -- },
  -- {
  --   'folke/lazydev.nvim', -- lsp for Neovim configuration
  --   ft = 'lua',
  --   opts = {
  --     library = {
  --       { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  --     },
  --   },
  -- },
}

--[[

LSP stands for Language Server Protocol. It's a protocol that helps editors and
language tooling communicate in a standardized fashion.

In general, you have a "server" which is some tool built to understand a
particular language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.).

These Language Servers are standalone processes that communicate with some
"client", in this case, Neovim!

LSP provides Neovim with features like:
  - Go to definition
  - Find references
  - Autocompletion
  - Symbol Search
  - and more!

Thus, Language Servers are external tools that must be installed separately
from Neovim. This is where `mason` and related plugins come into play.

For more information about LSP:
  [Understanding Neovim #7 - Language Server Protocol](https://www.youtube.com/watch?v=HL7b63Hrc8U&list=PLx2ksyallYzW4WNYHD9xOFrPRYGlntAft&index=7).
  `:h lsp`
  `:h lsp-defaults`
  `:h diagnostic-defaults`

Verify setup:
  Use `:LspInfo` to verify an LSP is attached to the buffer and everything is setup correctly.
  If not attached, see [common pitfalls](https://youtu.be/UVcC5ifbXL8?si=LJ8-DBjCPvQ3DZmr&t=439)

Capabilities:
  Neovim 11 already includes the capabilities that we used to add with Blink, so that code is not necessary anymore.
  To see Neovim client LSP builtin capabilities run `:=vim.lsp.protocol.make_client_capabilities()`.
  To see attached LSP capabilities run `:=vim.lsp.get_clients()[1].server_capabilities`.

Servers:
  Install LSPs using your package manager, that way they are available for the whole system, not just Neovim.
  Nvim-lspconfig uses custom names, e.g. for the `lua-language-server` it uses `lua_ls`. You can search here:
    [Mason - lspconfig](https://github.com/mason-org/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/filetype_mappings.lua)
    [Nvim-lspconfig - configs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md)
  Customize the behavior of each LSP by passong a table. Check each LSP website for available options.
    `:h lsp`
    [Lua settings](https://github.com/nvim-lua/kickstart.nvim/blob/3338d3920620861f8313a2745fd5d2be39f39534/init.lua#L667)

JavaScript / TypeScript:
  Replaced `typescript-language-server` (`ts_ls`) with 'pmizio/typescript-tools.nvim'.
  `ts_ls` does not support Styled-Components and is supposed to be awefully slow on big projects.
  `typescript-tools` has more commands than the ones binded to keymaps, use `:TSTools<Tab>` to see them.

--]]
