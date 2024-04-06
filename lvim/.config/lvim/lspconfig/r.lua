-- This is lspconfig/r.lua

local lspconfig = require('lspconfig')
local util = require('lspconfig').util

-- Setup for R language server
lspconfig.r_language_server.setup {
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
  filetypes = { "r", "rmd" },
  log_level = 2,
  root_dir = function(fname)
    return util.find_git_ancestor(fname) or vim.loop.os_homedir()
  end,
}
