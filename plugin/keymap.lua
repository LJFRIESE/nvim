
-- Manipulate text
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = '[d]elete | Black hole' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', [["_dP]], { desc = '[P]aste | Black hole' })
vim.keymap.set('n', '<c-p>', 'o<c-r>"<esc>', { desc = '[P]aste below' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })


vim.keymap.set('n', 'ok', 'mzO<esc>`z', { desc = 'Insert linebreak above' })
vim.keymap.set('n', 'oj', 'mzo<esc>`z', { desc = 'Insert linebreak below' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join subsequent line' })

vim.keymap.set('n', '<leader>rg', [[:%s/\\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[G]lobal' })
vim.keymap.set('n', '<leader>rl', [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[L]ine' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous [d]iagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next [d]iagnostic' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Current line [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '[Q]uickfix list' })

vim.keymap.set('n', 'gcd', 'O---@diagnostic disable-next-line<esc>j', { desc = '[d]isable diagnostic' })
vim.keymap.set('n', 'gcl', 'A--no lint<esc>', { desc = 'disable [l]int' })

-- Window navigation
vim.keymap.set('n', '|', '<c-w>v', { desc = 'Virtical split' })
vim.keymap.set('n', '<leader><', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<leader>>', '<C-w>l', { desc = 'Go to right window' })

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })

vim.keymap.set('n', '<c-d>', 'zz<c-d>', {desc = 'Jump down and center'})
vim.keymap.set('n', '<c-u>', 'zz<c-u>', {desc = 'Jump up and center'})

-- Misc
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Esc' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })
vim.keymap.set({ 'n' }, '<c-c>t', ':split<cr>:terminal<cr>i', { desc = '[t]erminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Escape terminal' })
-- vim.keymap.set({ 'n' }, '<leader>i', '<esc>i```{r}<cr>```<esc>O', { desc = '[i]nsert code chunk' })
-- Make U opposite to u.
  vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
-- Indent while remaining in visual mode.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Overloaded to toggle nvim-cmp documentation window as well.
vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
  require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = 'Toggle LSP signature' })

vim.keymap.set('n', '<leader>Z', function()
  require('zen-mode').toggle()
  vim.wo.wrap = false
  vim.wo.number = true
  vim.wo.rnu = true
end, { desc = '[Z]en mode' })


-- Which-key groupings
local wk = require('which-key')
wk.add({
  hidden = true,
  { '<leader>pv', '<cmd>Ex<cr>' }, --'<cmd>25Lex<cr>'
  { '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', desc = '[M]ake it [R]ain' },
})

wk.add({
  { 'g', group = '[G]o to ...' }, -- , icon = "󰈆 "},
  { 'gs', group = '[s]urrounding ...', icon = '' },
  { '<leader>s', group = '[S]earch ...', icon = '' },
  { '<leader>t', desc = '[T]rouble'},
  { '<leader>f', desc = '[F]ind ...', icon = '' },
  { '<leader>h', group = '[H]arpoon window' },
  { '<leader>b', group = '[B]uffer' },
  { '<leader>r', group = '[R]egex replace' },
  { 'z', group = 'Fold code' },
})

