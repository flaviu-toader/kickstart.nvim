-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

return {
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        columns = {
          'icon',
          'permissions',
          'size',
          'mtime',
        },
        default_file_explorer = true,
      }
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    keys = {
      '<leader>gg',
      '<leader>gf',
      '<leader>gc',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local wk = require 'which-key'
      wk.add {
        { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open LazyGit' },
        { '<leader>gf', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'Open LazyGit buffer commits' },
        { '<leader>gc', '<cmd>LazyGitFilter<cr>', desc = 'Open LazyGit commits' },
      }
    end,
  },
  {
    'github/copilot.vim',
  },
  {
    'amitds1997/remote-nvim.nvim',
    lazy = true,
    cmd = { 'RemoteStart' },
    version = '*', -- Pin to GitHub releases
    dependencies = {
      'nvim-lua/plenary.nvim', -- For standard functions
      'MunifTanjim/nui.nvim', -- To build the plugin UI
      'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
    },
    config = true,
  },
  {
    'olimorris/codecompanion.nvim',
    lazy = false,
    -- keys = {
    --   '<leader>aa',
    -- },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local wk = require 'which-key'
      wk.add {
        { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = 'Code Companion' },
        { '<leader>ac', '<cmd>CodeCompanionChat<cr>', desc = 'Code Companion Chat' },
        { '<leader>ai', '<cmd>CodeCompanion<cr>', desc = 'Code Companion Inline', mode = { 'n', 'v' } },
      }
      require('codecompanion').setup {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
      }
    end,
  },
  {
    'stevearc/overseer.nvim',
    lazy = true,
    keys = {
      '<leader>et',
      '<leader>ec',
      '<leader>er',
      '<leader>el',
    },
    config = function()
      local overseer = require 'overseer'
      local wk = require 'which-key'
      overseer.setup()
      wk.add {
        { '<leader>et', overseer.toggle, desc = 'Toggle overseer' },
        { '<leader>er', '<cmd>OverseerRun<cr>', desc = 'Overseer run' },
        { '<leader>er', '<cmd>OverseerShell<cr>', desc = 'Overseer shell command' },
      }
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    cmd = { 'ObsidianOpen', 'ObsidianToday' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      workspaces = {
        {
          name = 'work',
          path = '~/Documents/notes/work',
        },
      },
      daily_notes = {
        folder = 'dailies',
        date_format = '%Y-%m-%d',
        default_tags = { 'daily-notes' },
        template = nil,
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 25,
      open_mapping = [[<c-\>]],
      direction = 'horizontal',
    },
  },
}
