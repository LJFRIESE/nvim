return {
 {
  'Wansmer/treesj',
    event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({ max_join_length = 120, use_default_keymaps = false })
    vim.keymap.set('n', '<c-j>', require('treesj').toggle, {desc = 'Toggle [j]oin node'})
  end,
},
  { 'nvim-lua/plenary.nvim' },
  { 'eandrju/cellular-automaton.nvim', event = 'VeryLazy' },
  { 'tpope/vim-sleuth', event = 'VeryLazy' }, -- Detect tabstop and shiftwidth automatically
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'VeryLazy',
    config = function()
      require('nvim-highlight-colors').turnOn()
      vim.keymap.set('n', '<leader>c', function()
        require('nvim-highlight-colors').toggle()
      end, { desc = 'Toggle [c]olours' })
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'folke/zen-mode.nvim',
    event = 'BufReadPost',
    config = function()
      require('zen-mode').setup({
        window = {
          width = 90,
          options = {},
        },
      })
    end,
  },
}
