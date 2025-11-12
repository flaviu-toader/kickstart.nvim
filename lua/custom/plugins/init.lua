-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'github/copilot.vim',
  },
  {
    'stevearc/overseer.nvim',
    config = function()
      local overseer = require 'overseer'
      local wk = require 'which-key'
      overseer.setup()
      wk.add {
        { '<leader>et', overseer.toggle, desc = 'Toggle overseer' },
        { '<leader>ec', '<cmd>OverseerRunCmd<cr>', desc = 'Overseer run command' },
        { '<leader>er', '<cmd>OverseerRun<cr>', desc = 'Overseer run' },
        { '<leader>el', '<cmd>OverseerLoadBundle<cr>', desc = 'Overseer load bundle' },
      }
    end,
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = false,
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
}
