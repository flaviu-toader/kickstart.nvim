-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    opts = {},
  },
  {
    'olimorris/codecompanion.nvim',
    version = '^19.0.0',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'github/copilot.vim',
  },
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    config = function()
      require('blame').setup()
      vim.keymap.set('n', '<leader>tb', '<cmd>BlameToggle window<cr>', { desc = '[T]oggle [B]lame' })
    end,
  },
  {
    'tanvirtin/vgit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = 'VimEnter',
    config = function()
      require('vgit').setup()
      vim.keymap.set('n', '<leader>vh', '<cmd>VGit buffer_history_preview<cr>', { desc = '[V]Git Buffer [H]istory Preview' })
      vim.keymap.set('n', '<leader>vp', '<cmd>VGit project_diff_preview<cr>', { desc = '[V]Git [P]roject Diff Preview' })
    end,
  },
}
