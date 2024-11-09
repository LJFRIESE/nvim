return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      comments_only = false,
    },
  },
  init = function()
    require('todo-comments').setup()
  end,
}
