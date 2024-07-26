-- Manipulate text
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = '[d]elete | Black hole' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[P]aste over | Black hole' })
vim.keymap.set('n', '<c-p>', 'o<c-r>"<esc>', { desc = '[P]aste | New line' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })
vim.keymap.set('n', '<cr>', 'i<cr><esc>k$', { desc = 'Insert linebreak' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join subsequent line to current line' })
vim.keymap.set('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[R]egex' })

-- vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank | No clipboard' })
-- vim.keymap.set({ 'n', 'x' }, '<leader>Y', '"*Y', { desc = 'Yank | Yes clipboard' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Jump to next location' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Jump to prev location' })

-- Window navigation
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader><', '<cmd>vertical resize -5<cr>', { desc = 'Window size decrease' })
vim.keymap.set('n', '<leader>>', '<cmd>vertical resize +5<cr>', { desc = 'Window size increase' })

-- Misc
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Esc' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })
vim.keymap.set({ 'n' }, '<c-c>t', ':split<cr>:terminal<cr>i', { desc = '[t]erminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Escape terminal' })
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format current buffer' })
-- vim.keymap.set({ 'n' }, '<leader>i', '<esc>i```{r}<cr>```<esc>O', { desc = '[i]nsert code chunk' })

local config_path = vim.fn.stdpath('config')
local wk = require('which-key')
wk.add({
  hidden = true,
  { '<leader>pv', '<cmd>Ex<cr>' }, --'<cmd>25Lex<cr>'
  { '<leader>gc', ':cd ' .. config_path .. '<CR>', desc = '[G]o to [C]onfig' },
  { '<leader>gg', ':cd ~/git <CR>', desc = '[G]o to [G]it directory' },
  { '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', desc = '[M]ake it [R]ain' },
})

-- vim.keymap.set('n', 's', '<Nop>')
wk.add({
  { 's', group = '[S]urround' },
  { '<leader>r', group = '[R]eplace' },
  { 'g', group = '[G]o to ...' },
  { 'gs', group = '[S]urrounding ...' },
  { '<leader>t', group = '[T]rouble' },
  -- { '<leader>z', group = '[Z]en' },
  { '<leader>z', group = 'Fold control' },
  { '<leader>sy', group = '[Sy]mbols' },
  { '<leader>g', group = '[G]o to' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>c', group = '[C]omment' },
  { '<leader>h', group = '[H]arpoon' },
})
