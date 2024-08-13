local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  ui = {
    border = "rounded",
    title = "Lazy",
  },
  spec = 'ljfriese/plugins',
  change_detection = { notify = false },
})
-- Silence some checkhealth warnings
-- let g:loaded_node_provider = 0
-- let g:lgoaded_perl_provider = 0
-- let g:loaded_python3_provider =
--


