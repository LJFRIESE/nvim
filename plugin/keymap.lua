-- Manipulate text
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d', { desc = '[d]elete | Black hole' })
vim.keymap.set({'n', 'x'}, '<leader>p', [["_dP]], { desc = '[P]aste over | Black hole' })
-- vim.keymap.set('n', '<c-p>', 'o<c-r>"<esc>', { desc = '[P]aste | New line' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

vim.keymap.set('n', 'oo', '$i<right><cr><esc>k$', { desc = 'Insert linebreak above' })
vim.keymap.set('n', 'OO', '$ki<right><cr><esc>j$', { desc = 'Insert linebreak below' })

vim.keymap.set('n', '<C-j>', 'i<cr><esc>', { desc = 'Split current line' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join subsequent line to current line' })

vim.keymap.set('n', '<leader>rg', [[:%s/\\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[G]lobal replace' })
vim.keymap.set('n', '<leader>rl', [[:s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[L]ine replace' })

-- vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank | No clipboard' })
-- vim.keymap.set({ 'n', 'x' }, '<leader>Y', '"*Y', { desc = 'Yank | Yes clipboard' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Window navigation
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader><', '<cmd>vertical resize -5<cr>', { desc = 'Window size decrease' })
vim.keymap.set('n', '<leader>>', '<cmd>vertical resize +5<cr>', { desc = 'Window size increase' })

-- Misc
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Esc' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })
vim.keymap.set({ 'n' }, '<c-c>t', ':split<cr>:terminal<cr>i', { desc = '[t]erminal' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Escape terminal' })
-- vim.keymap.set({ 'n' }, '<leader>i', '<esc>i```{r}<cr>```<esc>O', { desc = '[i]nsert code chunk' })

vim.keymap.set('', '<leader>bf', function()
  require('conform').format({ async = true }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), 'v') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
      end
    end
  end)
  print('Format complete')
end, { desc = '[F]ormat' })

local config_path = vim.fn.stdpath('config')
local wk = require('which-key')
wk.add({
  hidden = true,
  { '<leader>pv', '<cmd>Ex<cr>' }, --'<cmd>25Lex<cr>'
  { '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', desc = '[M]ake it [R]ain' },
})

wk.add({{ 'n', ']}', desc = 'Jump to next instance of word under cursor' },
  { '<leader>gc', ':cd ' .. config_path .. '<CR>', desc = '[G]o to [C]onfig' },
  { '<leader>gg', ':cd ~/git <CR>', desc = '[G]o to [G]it directory' },})

-- No idea why t doesn't work
wk.add({ 't', group = '[T]rouble' })
-- vim.keymap.set('n', 's', '<Nop>')
wk.add({
  -- { 's', group = '[S]urround' },
  { '<leader>r', group = '[R]egex' },
  { 'g', group = '[G]o to ...' },
  { 'gs', group = '[s]urrounding ...' },
  -- { '<leader>z', group = '[Z]en' },
  -- { '<leader>z', group = 'Fold control' },
  { '<leader>sy', group = '[Sy]mbols' },
  { '<leader>g', group = '[G]o to' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>c', group = '[C]omment' },
  { '<leader>h', group = '[H]arpoon' },
  { '<leader>b', group = '[B]uffer' },
  { 'z', group = 'Fold code'},
})
