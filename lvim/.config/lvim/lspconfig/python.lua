-- This is lspconfig/python.lua

local lspconfig = require('lspconfig')
local formatters = require "lvim.lsp.null-ls.formatters"
local linters = require "lvim.lsp.null-ls.linters"

-- Setup for python language server
lspconfig.pyright.setup {}

-- setup formatting
formatters.setup {
  { name = "black", filetypes = { "python" } },
}

-- setup linting
linters.setup {
  {
    name = "flake8",
    args = { "--max-line-length", "88" },
    filetypes = { "python" }
  },
  { name = "mypy", filetypes = { "python" } },
}
