return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format()
      end,
      desc = "Format (Conform)",
    },
  },
  opts = { -- `:h conform.setup`
    formatters_by_ft = {
      lua = { "stylua", lsp_format = "never" },
      markdown = { "biome" },
      css = { "biome" },
      javascript = { "biome" },
      typescript = { "biome" },
      json = { "biome" },
      jsonc = { "biome" },
      sh = { "shfmt", lsp_format = "fallback" },
    },
    default_format_opts = {
      async = true, -- do not block
      lsp_format = "fallback", -- never, fallback, prefer, first, last
      stop_after_first = true,
    },
    format_on_save = true,
    notify_on_error = true,
    notify_no_formatters = true,
  },
}

--[[

Install formatters using you package manager. For a list of formatters see:
  `:h conform-formatters`
  https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters

Options to customize a formatter:
  `:h conform.format`
  https://github.com/stevearc/conform.nvim#options

Verify:
  `:checkhealth conform`
  `:ConformInfo`

--]]
