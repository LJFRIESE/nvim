return {
  'folke/which-key.nvim',
  lazy=false,
  event = 'VimEnter',
  opts = {
    preset = 'helix',
    expand = -1,
    sort = { 'local', 'order', 'alphanum', 'mod', 'group' },
  },
  keys = {
    {
      '<leader>b?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps',
    },
  },
}
