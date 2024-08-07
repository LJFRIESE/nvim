return {
  { 'eandrju/cellular-automaton.nvim',lazy=true },
  { 'nvim-lua/plenary.nvim', },
  { 'tpope/vim-sleuth',}, -- Detect tabstop and shiftwidth automatically }
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}
