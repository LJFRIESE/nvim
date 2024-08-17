return {
  'mbbill/undotree',
  events = 'VeryLazy',
  opts = {},
  config = function()
    vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle, { desc = 'Toggle UndoTree' })
  end,
}
