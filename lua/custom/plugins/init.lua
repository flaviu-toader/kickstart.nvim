-- Custom plugins
-- Migrated from lazy.nvim to vim.pack (Neovim 0.12+)

local function gh(repo) return 'https://github.com/' .. repo end
local function codeberg(repo) return 'https://codeberg.org/' .. repo end
local wk = require 'which-key'

-- Build hook for mcphub.nvim
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'mcphub.nvim' then
      if ev.data.kind == 'install' or ev.data.kind == 'update' then
        vim.system({ 'npm', 'install', '-g', 'mcp-hub@latest' }):wait()
      end
    end
  end,
})

-- oil.nvim - file explorer as a buffer
-- mini.icons provides nvim-web-devicons compatibility (set up in init.lua)
vim.pack.add { gh 'stevearc/oil.nvim' }
require('oil').setup {}

-- copilot.lua - GitHub Copilot integration
vim.pack.add { gh 'zbirenbaum/copilot.lua' }
require('copilot').setup {}

-- mcphub.nvim - MCP Hub integration
vim.pack.add {
  gh 'ravitemer/mcphub.nvim',
  gh 'nvim-lua/plenary.nvim',
}
require('mcphub').setup()
vim.keymap.set('n', '<leader>mh', '<cmd>MCPHub<cr>', { desc = '[M]CP [H]ub' })

-- codecompanion.nvim - AI coding assistant
vim.pack.add {
  gh 'olimorris/codecompanion.nvim',
  gh 'nvim-treesitter/nvim-treesitter',
  -- plenary.nvim and copilot.lua already added above
}
require('codecompanion').setup {
  interactions = {
    chat = { adapter = 'copilot' },
    inline = { adapter = 'copilot' },
    agent = { adapter = 'copilot' },
    background = { adapter = 'copilot' },
    cli = {
      agent = 'copilot',
      agents = {
        copilot = {
          cmd = 'copilot',
          args = {},
          description = 'Copilot CLI',
          provider = 'terminal',
        },
      },
    },
  },
  opts = {
    auto_submit_errors = true,
    auto_submit_success = true,
    agentic = true,
  },
  extensions = {
    mcphub = {
      callback = 'mcphub.extensions.codecompanion',
      opts = {
        make_vars = false, -- disabled: codecompanion v19 has no variables API
        make_slash_commands = true, -- MCP prompts become /slash commands
        show_result_in_chat = true,
      },
    },
  },
}

-- vgit.nvim - visual git integration
vim.pack.add { gh 'tanvirtin/vgit.nvim' }
require('vgit').setup()
vim.keymap.set('n', '<leader>vh', '<cmd>VGit buffer_history_preview<cr>', { desc = '[V]Git Buffer [H]istory Preview' })
vim.keymap.set('n', '<leader>vp', '<cmd>VGit project_diff_preview<cr>', { desc = '[V]Git [P]roject Diff Preview' })

-- gh.nvim - GitHub integration via litee
vim.pack.add {
  gh 'ldelossa/litee.nvim',
  gh 'ldelossa/gh.nvim',
}
require('litee.lib').setup()
require('litee.gh').setup()
wk.add {
  { '<leader>g', group = 'Git' },
  { '<leader>gh', group = 'Github' },
  { '<leader>ghc', group = 'Commits' },
  { '<leader>ghcc', '<cmd>GHCloseCommit<cr>', desc = 'Close' },
  { '<leader>ghce', '<cmd>GHExpandCommit<cr>', desc = 'Expand' },
  { '<leader>ghco', '<cmd>GHOpenToCommit<cr>', desc = 'Open To' },
  { '<leader>ghcp', '<cmd>GHPopOutCommit<cr>', desc = 'Pop Out' },
  { '<leader>ghcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
  { '<leader>ghi', group = 'Issues' },
  { '<leader>ghip', '<cmd>GHPreviewIssue<cr>', desc = 'Preview' },
  { '<leader>ghl', group = 'Litee' },
  { '<leader>ghlt', '<cmd>LTPanel<cr>', desc = 'Toggle Panel' },
  { '<leader>ghp', group = 'Pull Request' },
  { '<leader>ghpc', '<cmd>GHClosePR<cr>', desc = 'Close' },
  { '<leader>ghpd', '<cmd>GHPRDetails<cr>', desc = 'Details' },
  { '<leader>ghpe', '<cmd>GHExpandPR<cr>', desc = 'Expand' },
  { '<leader>ghpo', '<cmd>GHOpenPR<cr>', desc = 'Open' },
  { '<leader>ghpp', '<cmd>GHPopOutPR<cr>', desc = 'PopOut' },
  { '<leader>ghpr', '<cmd>GHRefreshPR<cr>', desc = 'Refresh' },
  { '<leader>ghpt', '<cmd>GHOpenToPR<cr>', desc = 'Open To' },
  { '<leader>ghpz', '<cmd>GHCollapsePR<cr>', desc = 'Collapse' },
  { '<leader>ghr', group = 'Review' },
  { '<leader>ghrb', '<cmd>GHStartReview<cr>', desc = 'Begin' },
  { '<leader>ghrc', '<cmd>GHCloseReview<cr>', desc = 'Close' },
  { '<leader>ghrd', '<cmd>GHDeleteReview<cr>', desc = 'Delete' },
  { '<leader>ghre', '<cmd>GHExpandReview<cr>', desc = 'Expand' },
  { '<leader>ghrs', '<cmd>GHSubmitReview<cr>', desc = 'Submit' },
  { '<leader>ghrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
  { '<leader>ght', group = 'Threads' },
  { '<leader>ghtc', '<cmd>GHCreateThread<cr>', desc = 'Create' },
  { '<leader>ghtn', '<cmd>GHNextThread<cr>', desc = 'Next' },
  { '<leader>ghtt', '<cmd>GHToggleThread<cr>', desc = 'Toggle' },
}

-- -- nvim-dap - Neovim Debug Adapter Protocol
-- vim.pack.add {
--   codeberg 'mfussenegger/nvim-dap',
--   gh 'igorlfs/nvim-dap-view'
-- }
-- local dap = require('dap')
-- wk.add {
--   { '<leader>d', group = 'Debug' },
--   { '<leader>db', function() dap.toggle_breakpoint() end, desc = 'Toggle breakpoint', mode = 'n' },
--   { '<leader>dc', function() dap.continue() end, desc = 'DAP Start / Continue', mode = 'n' },
--   { '<leader>ds', function() dap.step_over() end, desc = 'Step Over' },
--   { '<leader>do', function() dap.step_into() end, desc = 'Step Into' },
--   { '<leader>dr', function() dap.repl.open() end, desc = 'REPL' },
--   { '<leader>dvo', '<cmd>DapViewOpen<cr>', desc = 'DAP View Open' },
--   { '<leader>dvo', '<cmd>DapViewClose<cr>', desc = 'DAP View Close' },
-- }
