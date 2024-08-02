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

-- Useful plugin to show you pending keybinds.
-- 'folke/which-key.nvim',
-- event = 'VimEnter', -- Sets the loading event to 'VimEnter'
-- config = function() -- This is the function that runs, AFTER loading
--   require('which-key').setup()
--
