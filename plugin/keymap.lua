-- Manipulate text
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = '[d]elete | Black hole' })
vim.keymap.set({ 'n', 'x' }, '<leader>p', [["_dP]], { desc = '[P]aste over | Black hole' })
vim.keymap.set('n', '<c-p>', 'o<c-r>"<esc>', { desc = '[P]aste | New line' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

vim.keymap.set('n', 'oo', '$i<right><cr><esc>k$', { desc = 'Insert linebreak above' })
vim.keymap.set('n', 'OO', '$ki<right><cr><esc>j$', { desc = 'Insert linebreak below' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join subsequent line to current line' })

vim.keymap.set('n', '<leader>rg', [[:%s/\\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[G]lobal replace' })
vim.keymap.set('n', '<leader>rl', [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[L]ine replace' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
vim.keymap.set('n', '<leader><', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<leader>>', '<C-w>l', { desc = 'Go to right window' })

-- Misc
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Esc' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })
vim.keymap.set({ 'n' }, '<c-c>t', ':split<cr>:terminal<cr>i', { desc = '[t]erminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Escape terminal' })
-- vim.keymap.set({ 'n' }, '<leader>i', '<esc>i```{r}<cr>```<esc>O', { desc = '[i]nsert code chunk' })

vim.keymap.set('n', 'gcd', 'O---@diagnostic disable-next-line<esc>j', { desc = 'disable diagnostic' })

local wk = require('which-key')
wk.add({
  hidden = true,
  { '<leader>pv', '<cmd>Ex<cr>' }, --'<cmd>25Lex<cr>'
  { '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', desc = '[M]ake it [R]ain' },
})
-- vim.keymap.set({ 'n', 'i' }, '<C-k>', function()
--   require('lsp_signature').toggle_float_win()
-- end, { silent = true, noremap = true, desc = 'toggle signature' })

vim.keymap.set('n', '<leader>Z', function()
  require('zen-mode').toggle()
  vim.wo.wrap = false
  vim.wo.number = true
  vim.wo.rnu = true
end, { desc = '[Z]en mode' })

-- vim.keymap.set('n', 'fm', function()
--   require('ufo').closeAllFolds()
-- end, { desc = '󱃄 Close All Folds' })
--
-- vim.keymap.set('n', 'fr', function()
--   require('ufo').openFoldsExceptKinds({ 'comment', 'imports' })
--   vim.opt.scrolloff = vim.g.baseScrolloff -- fix scrolloff setting sometimes being off
-- end, { desc = '󱃄 Open All Regular Folds' })
--
-- vim.keymap.set('n', 'fR', function()
--   require('ufo').openFoldsExceptKinds({})
-- end, { desc = '󱃄 Open All Folds' })

-- No idea why t doesn't work
-- wk.add({ 'tt', group = '[T]rouble' })
-- vim.keymap.set('n', 's', '<Nop>')
wk.add({
  { 'g', group = '[G]o to ...' }, -- , icon = "󰈆 "},
  { 'gs', group = '[s]urrounding ...', icon = '' },
  { '<leader>s', group = '[S]earch ...', icon = '' },
  { 't', desc = '[T]rouble'},
  { 'f', desc = '[F]ind ...', icon = '' },
  { '<leader>h', group = '[H]arpoon window' },
  { '<leader>b', group = '[B]uffer' },
  { '<leader>r', group = '[R]egex replace' },
  { 'z', group = 'Fold code' },
})
