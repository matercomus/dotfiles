-- Plugin configuration
lvim.plugins = {
  "christoomey/vim-tmux-navigator",
  "ChristianChiarulli/swenv.nvim",
  "stevearc/dressing.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-neotest/neotest",
  "nvim-neotest/neotest-python",
  "folke/zen-mode.nvim",
  "nvim-lua/plenary.nvim",
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    opts = {
      debug = true, -- Enable debugging
      window = {
        layout = 'vertical',
        width = 0.4,
      },
      mappings = {
        reset = {
          normal = '<C-x>',
          insert = '<C-x>'
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      -- Code related commands
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
      { "<leader>aT", "<cmd>CopilotChatToggle<cr>",        desc = "CopilotChat - Toggle" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
      -- Debug
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>",     desc = "CopilotChat - Debug Info" },
      { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>",         desc = "CopilotChat - Clear buffer and chat history" },
      -- Custom input for CopilotChat
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Quick chat with Copilot
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
    },
  },
}



-- Add the configs to package path
package.path = package.path .. ';/home/matt/.dotfiles/lvim/.config/lvim/lspconfig/?.lua'

-- Require the language server configurations
require('python')
require('lua')
require('r')
require('js_ts')
require('shell')

-- Automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- Setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "black", filetypes = { "python" } },
  { name = "shfmt", filetypes = { "sh" } },
}

-- Remove "docker_compose_language_service" from skipped servers
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(value)
  return value ~= "docker_compose_language_service"
end, lvim.lsp.automatic_configuration.skipped_servers)

lvim.format_on_save.enabled = false

-- Copilot setup
local ok, copilot = pcall(require, "copilot")
if ok then
  copilot.setup {
    suggestion = {
      keymap = {
        accept = "<c-l>",
        next = "<c-j>",
        prev = "<c-k>",
        dismiss = "<c-h>",
      },
    },
  }

  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)
end
