vim.keymap.set('n', '<leader>cdconf', ':cd C:/Users/LUCASFRI/AppData/Local/nvim<CR>')
vim.keymap.set('n', '<leader>cdgit', ':cd C:/Users/LUCASFRI/git <CR>')
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal  ode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Move current line up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
-- Join subsequent line to current line
vim.keymap.set('n', 'J', 'mzJ`z')
-- Jump up/down half page
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- vim.keymap.set('n', 'n', 'nzzzv')
-- vim.keymap.set('n', 'N', 'Nzzzv')

-- toggle vimwithme plugin
vim.keymap.set('n', '<leader>vwm', function()
  require('vim-with-me').StartVimWithMe()
end)
vim.keymap.set('n', '<leader>svwm', function()
  require('vim-with-me').StopVimWithMe()
end)

-- -- Uncomment once I know what x mode is....
-- -- greatest remap ever
-- vim.keymap.set('x', '<leader>p', [["_dP]])
--
-- Related to keeping seperate clipboards. yy goes to system, this does not
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
-- This does go to system
vim.keymap.set('n', '<leader>Y', [["+Y]])
-- Delete line without overwriting clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- This is going to get me cancelled
vim.keymap.set('i', '<C-c>', '<Esc>')

vim.keymap.set('n', 'Q', '<nop>')
--[[ vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>') ]]
-- vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format current buffer' })

vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = 'Jump to next error' })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = 'Jump to prev error' })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Jump to next location' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Jump to prev location' })

vim.keymap.set('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Find and [R]eplace in current buffer' })
-- Linux specific command to send cmd to terminal
--vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- Template for error handling in... Go?
--vim.keymap.set('n', '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>')

vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = '[M]ake it [R]ain' })

vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end, { desc = '[S]hout [O]ut' })

-- Harpoon
local harpoon = require 'harpoon'
vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'Add to harpoon' })
vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Open harpoon UI' })

vim.keymap.set('n', '<C-h>', function()
  harpoon:list():select(1)
end, { desc = 'Select harpoon 1' })
vim.keymap.set('n', '<C-t>', function()
  harpoon:list():select(2)
end, { desc = 'Select harpoon 2' })
vim.keymap.set('n', '<C-n>', function()
  harpoon:list():select(3)
end, { desc = 'Select harpoon 3' })
vim.keymap.set('n', '<C-s>', function()
  harpoon:list():select(4)
end, { desc = 'Select harpoon 4' })

vim.keymap.set('n', '<leader><C-h>', function()
  harpoon:list():replace_at(1)
end, { desc = 'Replace harpoon 1' })
vim.keymap.set('n', '<leader><C-t>', function()
  harpoon:list():replace_at(2)
end, { desc = 'Replace harpoon 2' })
vim.keymap.set('n', '<leader><C-n>', function()
  harpoon:list():replace_at(3)
end, { desc = 'Replace harpoon 3' })
vim.keymap.set('n', '<leader><C-s>', function()
  harpoon:list():replace_at(4)
end, { desc = 'Replace harpoon 4' })

-- Commenting
vim.keymap.set('n', 'gcc', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true, desc = 'Toggle comment selection' })

-- Toggle in Op-pending mode
vim.keymap.set('n', 'gc', '<Plug>(comment_toggle_linewise)', { desc = 'Toggle comment for selection' })

-- Toggle in VISUAL mode
vim.keymap.set('x', 'gc', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment for selection' })
--
