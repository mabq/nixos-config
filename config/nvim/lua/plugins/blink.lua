return {
  -- Autocompletion that supports LSPs, cmdline, signature help and snippets.
  "saghen/blink.cmp",
  version = "1.*", -- use a release tag to download pre-built binaries
  dependencies = {
    { "rafamadriz/friendly-snippets" }, -- snippet source
    { "moyiz/blink-emoji.nvim" }, -- emoji source
  },
  opts = {
    keymap = { preset = "default" }, -- see https://cmp.saghen.dev/configuration/keymap.html#default
    appearance = {
      nerd_font_variant = "mono", -- adjusts spacing to ensure icons are aligned
    },
    completion = {
      documentation = {
        auto_show = false, -- only show the documentation popup when manually triggered
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "emoji" },
      providers = {
        emoji = {
          name = "Emoji",
          module = "blink-emoji",
        },
      },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" }, -- https://cmp.saghen.dev/configuration/fuzzy.html
  },
  opts_extend = { "sources.default" },
}
