return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}

-- Useful plugin to show you pending keybinds.
-- 'folke/which-key.nvim',
-- event = 'VimEnter', -- Sets the loading event to 'VimEnter'
-- config = function() -- This is the function that runs, AFTER loading
--   require('which-key').setup()
--
