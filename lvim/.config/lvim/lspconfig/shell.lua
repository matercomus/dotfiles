-- This is lspconfig/shell.lua

local formatters = require "lvim.lsp.null-ls.formatters"

-- setup formatting
formatters.setup {
  { name = "shfmt", filetypes = { "sh" } },
}
