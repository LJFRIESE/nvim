return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    -- local conf = require('telescope.config').values
    -- local function toggle_telescope(harpoon_files)
    --   local file_paths = {}
    --   for _, item in ipairs(harpoon_files.items) do
    --     table.insert(file_paths, item.value)
    --   end
    --
    --   require('telescope.pickers')
    --     .new({}, {
    --       prompt_title = 'Harpoon',
    --       finder = require('telescope.finders').new_table({
    --         results = file_paths,
    --       }),
    --       previewer = conf.file_previewer({}),
    --       sorter = conf.generic_sorter({}),
    --     })
    --     :find()
    -- end
    harpoon:setup()
    vim.keymap.set('n', '<leader>e', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Open harpoon window' })
    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n',
      '<leader>H',
      function()
        harpoon:list():prev()
      end,
      {desc = 'Open prev Harpoon window'}
      )
    vim.keymap.set('n',
      '<leader>L',
      function()
        harpoon:list():next()
      end,
      {desc = 'Open next Harpoon window'}
      )
    vim.keymap.set('n', '<leader>a', function()
      harpoon:list():add()
    end, { desc = 'Add to harpoon' })
    vim.keymap.set('n', '<M-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Select harpoon 1' })
    vim.keymap.set('n', '<M-j>', function()
      harpoon:list():select(2)
    end, { desc = 'Select harpoon 2' })
    vim.keymap.set('n', '<M-k>', function()
      harpoon:list():select(3)
    end, { desc = 'Select harpoon 3' })
    vim.keymap.set('n', '<M-l>', function()
      harpoon:list():select(4)
    end, { desc = 'Select harpoon 4' })
    vim.keymap.set('n', '<leader>hH', function()
      harpoon:list():replace_at(1)
    end, { desc = 'Replace harpoon 1' })
    vim.keymap.set('n', '<leader>hJ', function()
      harpoon:list():replace_at(2)
    end, { desc = 'Replace harpoon 2' })
    vim.keymap.set('n', '<leader>hK', function()
      harpoon:list():replace_at(3)
    end, { desc = 'Replace harpoon 3' })
    vim.keymap.set('n', '<leader>hL', function()
      harpoon:list():replace_at(4)
    end, { desc = 'Replace harpoon 4' })
  end,
}
