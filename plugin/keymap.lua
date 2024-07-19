local wk = require 'which-key'
-- Undotree
vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
-- Harpoon

local harpoon = require 'harpoon'
wk.add {
  '<leader>h',
  group = '[H]arpoon',
  {
    -- Toggle previous & next buffers stored within Harpoon list
    -- {
    --   '<leader>H',
    --   function()
    --     harpoon:list():prev()
    --   end,
    -- },
    -- {
    --   '<leader>L',
    --   function()
    --     harpoon:list():next()
    --   end,
    -- },
    --
    {
      '<leader>ha',
      function()
        harpoon:list():add()
      end,
      desc = 'Add to harpoon',
    },
    {
      '<leader>he',
      function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Open harpoon UI',
    },

    {
      '<leader>hh',
      function()
        harpoon:list():select(1)
      end,
      desc = 'Select harpoon 1',
    },
    {
      '<leader>hj',
      function()
        harpoon:list():select(2)
      end,
      desc = 'Select harpoon 2',
    },
    {
      '<leader>hk',
      function()
        harpoon:list():select(3)
      end,
      desc = 'Select harpoon 3',
    },
    {
      '<leader>hl',
      function()
        harpoon:list():select(4)
      end,
      desc = 'Select harpoon 4',
    },

    {
      '<leader>hH',
      function()
        harpoon:list():replace_at(1)
      end,
      desc = 'Replace harpoon 1',
    },
    {
      '<leader>hJ',
      function()
        harpoon:list():replace_at(2)
      end,
      desc = 'Replace harpoon 2',
    },
    {
      '<leader>hK',
      function()
        harpoon:list():replace_at(3)
      end,
      desc = 'Replace harpoon 3',
    },
    {
      '<leader>hL',
      function()
        harpoon:list():replace_at(4)
      end,
      desc = 'Replace harpoon 4',
    },
  },
}
-- [C]ommenting
wk.add {
  { '<leader>c', group = '[C]omment' },
}
vim.keymap.set('n', '<leader>cc', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true, desc = 'Toggle comment' })
vim.keymap.set('n', 'cc', '<Plug>(comment_toggle_linewise)', { desc = 'Toggle comment {motion}' })
vim.keymap.set('x', '<leader>cc', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment' })

vim.keymap.set('n', '<leader>cb', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_blockwise_current)' or '<Plug>(comment_toggle_blockwise_count)'
end, { expr = true, desc = 'Toggle comment block' })
vim.keymap.set('n', 'cb', '<Plug>(comment_toggle_blockwise)', { desc = 'Toggle block comment {motion}' })
vim.keymap.set('x', '<leader>cb', '<Plug>(comment_toggle_blockwise_visual)', { desc = 'Toggle block comment' })

-- Fugitive
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Launch Fugitive ([G]it [S]tuff)' })

-- Telescope
-- [S]earch
-- See `:help telescope.builtin`
wk.add {
  { '<leader>s', group = '[S]earch' },
}
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[S]earch [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- Trouble
-- vim.keymap.set('n', '<leader>tt', function()
--   require('trouble').toggle()
-- end, { desc = '[T]oggle [t]rouble' })
-- vim.keymap.set('n', '[t', function()
--   require('trouble').next { skip_groups = true, jump = true }
-- end, { desc = 'Jump to next error' })
-- vim.keymap.set('n', ']t', function()
--   require('trouble').previous { desc = 'Jump to prev error', skip_groups = true, jump = true }
-- end, { desc = 'Jump to prev error' })

-- toggle vimwithme plugin
-- vim.keymap.set('n', '<leader>vwm', function()
--   require('vim-with-me').StartVimWithMe()
-- end, { desc = 'Start vimwithme' })
-- vim.keymap.set('n', '<leader>svwm', function()
--   require('vim-with-me').StopVimWithMe()
-- end, { desc = 'Stop vimwithme' })

-- Misc
vim.keymap.set('n', '<leader>pv', '<cmd>Neotree toggle<cr>', { desc = 'Toggle file tree' })

vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format current buffer' })
wk.add {
  { '<leader>d', group = '[D]elete' },
}
vim.keymap.set({ 'n', 'x' }, '<leader>y', [["+y]], { desc = 'Yank | No clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>Y', [["+Y]], { desc = 'Yank | Yes clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', [["_d]], { desc = '[D]elete | No clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>D', [["_D]], { desc = '[D]elete | Clipboard' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[P]aste over | Retain yank' })

-- Move current line up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Join subsequent line to current line
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join subsequent line to current line' })

-- Jump up/down half page
vim.keymap.set('n', '<J>', '<C-d>zz', { desc = 'Jump half-page down' })
vim.keymap.set('n', '<K>', '<C-u>zz', { desc = 'Jump half-page up' })

-- Navigate text
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = 'Jump to next error' })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = 'Jump to prev error' })
-- vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Jump to next location' })
-- vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Jump to prev location' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Find and [R]eplace in current buffer' })

-- Pane navigation
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- vim.keymap.set('n', '<leader>-', '<cmd>vertical resize -5<cr>', { desc = 'Window size decrease' })
-- vim.keymap.set('n', '<leader>=', '<cmd>vertical resize +5<cr>', { desc = 'Window size increase' })
--
wk.add {
  { '<leader>g', group = '[G]o to' },
}
vim.keymap.set('n', '<leader>gc', ':cd C:/Users/LUCASFRI/AppData/Local/nvim<CR>', { desc = '[G]o to [C]onfig' })
vim.keymap.set('n', '<leader>gg', ':cd C:/Users/LUCASFRI/git <CR>', { desc = '[G]o to [G]it directory' })

vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = '[M]ake it [R]ain' })

vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Esc' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })

wk.add {
  { '<leader>r', group = '[R]eplace' },
}
wk.add {
  { '<leader>t', group = '[T]rouble' },
}
wk.add {
  { '<leader>z', group = '[Z]en' },
}

vim.keymap.set({ 'n' }, '<leader>ii', '<esc>i```{r}<cr>```<esc>O', { desc = '[i]nsert code chunk' })
vim.keymap.set({ 'n' }, '<leader>ci', ':split  term://r<cr>', { desc = '[c]ode [i]nterpreter' })
