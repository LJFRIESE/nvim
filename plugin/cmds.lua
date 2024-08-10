vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

function R(name)
  require('plenary.reload').reload_module(name)
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 100,
    })
  end,
})

local ljfriesGroup = augroup('ljfries', {})
-- Search for word under cursor
autocmd({ 'BufWritePre' }, {
  group = ljfriesGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})


