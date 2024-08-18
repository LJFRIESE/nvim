return {
  'folke/which-key.nvim',
  lazy = false,
  event = 'VimEnter',
  opts = {
    triggers = {
      { '<auto>', mode = 'nxsot' },
      { mode = 'n', 't' },
      { mode = 'n', 'f' },
    },
    preset = 'helix',
    expand = -1,
    sort = { 'local', 'group','order', 'alphanum', 'mod' },
  },
}
