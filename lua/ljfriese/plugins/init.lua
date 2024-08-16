return {
  { 'eandrju/cellular-automaton.nvim'},
  { 'nvim-lua/plenary.nvim' },
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
    { 'brenoprata10/nvim-highlight-colors',
    config = function()
      require("nvim-highlight-colors").turnOn()
      vim.keymap.set('n', '<leader>c', function()
          require('nvim-highlight-colors').toggle()
        end, { desc = 'Toggle [c]olours' })

    end},
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
}}

