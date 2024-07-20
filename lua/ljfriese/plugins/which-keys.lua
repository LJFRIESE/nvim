return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    expand = -1,
    --- Mappings are sorted using configured sorters and natural sort of the keys
    --- Available sorters:
    --- * local: buffer-local mappings first
    --- * order: order of the items (Used by plugins like marks / registers)
    --- * group: groups last
    --- * alphanum: alpha-numerical first
    --- * mod: special modifier keys last
    --- * manual: the order the mappings were added
    --- * case: lower-case first
    sort = { 'local', 'order', 'alphanum', 'mod', 'group' },
  },
  -- keys = {
  --   -- {
  --   '<leader>?',
  --   function()
  --     require('which-key').show { global = false }
  --   end,
  --   desc = 'Buffer Local Keymaps (which-key)',
  -- },
  -- },
}

-- Useful plugin to show you pending keybinds.
-- 'folke/which-key.nvim',
-- event = 'VimEnter', -- Sets the loading event to 'VimEnter'
-- config = function() -- This is the function that runs, AFTER loading
--   require('which-key').setup()
--
