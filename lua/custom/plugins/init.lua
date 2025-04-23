-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'amitds1997/remote-nvim.nvim',
    version = '*', -- Pin to GitHub releases
    dependencies = {
      'nvim-lua/plenary.nvim', -- For standard functions
      'MunifTanjim/nui.nvim', -- To build the plugin UI
      'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
    },
    config = function()
      require('remote-nvim').setup {
        client_callback = function(port, workspace_config)
          local cmd = ('wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s'):format(
            port,
            ("'Remote: %s'"):format(workspace_config.host)
          )
          if vim.env.TERM == 'tmux-256color' then
            cmd = ('tmux new-window -n remote nvim --server localhost:%s --remote-ui'):format(port)
          end
          if vim.env.TERM == 'xterm-kitty' then
            -- cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
            cmd = ("kitten @ launch --type tab --title 'remote' nvim --server localhost:%s --remote-ui"):format(port)
          end
          if vim.g.neovide then
            cmd = ('neovide --server localhost:%s'):format(port)
          end
          vim.fn.jobstart(cmd, {
            detach = true,
            on_exit = function(job_id, exit_code, event_type)
              -- This function will be called when the job exits
              print('Client', job_id, 'exited with code', exit_code, 'Event type:', event_type)
            end,
          })
        end,
        remote = {
          copy_dirs = {
            config = {
              base = '/home/flaviu/.config/nvim',
              dirs = '*',
              compression = {
                enabled = false, -- Should compression be enabled or not
                additional_opts = {}, -- Any additional options that should be used for compression. Any argument that is passed to `tar` (for compression) can be passed here as separate elements.
              },
            },
          },
        },
      }
    end,
  },
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
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            -- Make sure you have an OPENAI_API_KEY env var with the api key for this to work
            adapter = 'openai',
          },
          inline = {
            adapter = 'openai',
          },
        },
      }
    end,
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
    lazy = true,
    ft = 'markdown',
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
