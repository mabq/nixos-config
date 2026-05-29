return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format()
      end,
      mode = '',
      desc = 'Format (Conform)',
    },
  },
  opts = {
    formatters_by_ft = {
      -- Add more than one to run them sequentially.
      -- For customization options see `:h conform.format`
      lua = { 'stylua', lsp_format = false },
      css = { 'biome', stop_after_first = true },
      javascript = { 'biome' },
      typescript = { 'biome' },
      json = { 'biome' },
      jsonc = { 'biome' },
      markdown = { 'biome' },
      sh = { 'shfmt' },
    },
    default_format_opts = {
      async = true,
      lsp_format = 'fallback',
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
  },
}

--[[

Install formatters using you package manager. For a list of formatters see:
  https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
  `:h conform-formatters`

Options to customize a formatter:
  https://github.com/stevearc/conform.nvim#options
  `:h conform.format`

Verify:
  `:checkhealth conform`
  `:ConformInfo`

--]]
