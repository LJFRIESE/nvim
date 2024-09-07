
-- INFO: fold commands usually change the foldlevel, which fixes folds, e.g.
-- auto-closing them after leaving insert mode, however ufo does not seem to
-- have equivalents for zr and zm because there is no saved fold level.
-- Consequently, the vim-internal fold levels need to be disabled by setting
-- them to 99.
vim.opt.fillchars = {
  horiz = '─',
  horizup = '┴',
  horizdown = '┬',
  vert = '│',
  vertleft = '┤',
  vertright = '├',
  verthoriz = '┼',
  fold = ' ',
  foldopen = '⎧',
  foldclose = '',
  foldsep = '│',
}
local fcs = vim.opt.fillchars:get()

local function get_fold(lnum)
  if vim.fn.foldclosedend(lnum - 1) ~= -1 then
    return ''
  end
  -- series of non-folded lines
  if vim.fn.foldlevel(lnum) == 0 and vim.fn.foldlevel(lnum - 1) == 0 then
    return ''
  end
  -- series of lines within same fold
  if vim.fn.foldlevel(lnum) == vim.fn.foldlevel(lnum - 1) and vim.fn.foldlevel(lnum) == vim.fn.foldlevel(lnum - 1) then
    return '⎜'
  end
  -- line whose prior fold is greater, but subsequent is same
  if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) and vim.fn.foldlevel(lnum) == vim.fn.foldlevel(lnum + 1) then
    return '⎝'
  end
  if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
    return '⎝'
  end
  -- line is a top-level fold
  if vim.fn.foldlevel(lnum) == 1 then
    return '⯈'
  end
  -- line at the end of a top-level fold. Prior line was inside a fold
  if vim.fn.foldlevel(lnum) == 0 then
    return '⎝'
  end
  -- line is start of a non-top level fold
  return vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose
end

local function line_func()
  return vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum
end
_G.get_statuscol = function()
  return '%s%{' .. line_func() .. '}%= ' .. get_fold(vim.v.lnum) .. ' '
end



-- netrw
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0

-- ui
vim.g.have_nerd_font = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.termguicolors = true

vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver100-Cursor,r-cr-o:hor100'
vim.opt.statuscolumn = '%!v:lua.get_statuscol()'
vim.opt.colorcolumn = { '89' }
vim.opt.textwidth = 88

vim.opt.relnum = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = 'split'-- Preview substitutions live

vim.opt.ignorecase = true-- Case-insensitive searching
vim.opt.smartcase = true--UNLESS \C or one or more capital letters in the search term

vim.opt_global.sidescroll = 20
vim.opt_global.scrolloff = 8

vim.opt.pumheight = 10-- Max n suggestions in popups

-- windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- whitespace
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true
vim.opt.smartindent = true

-- Plugins
vim.opt.timeoutlen = 300-- Decrease mapped sequence wait time
vim.b.slime_cell_delimiter = '```'

-- misc
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.opt.backup = false

vim.opt.undofile = true
vim.opt.undofile = true-- Save undo history
vim.g.undotree_DiffCommand = 'FC'

vim.opt.isfname:append('@-@')

--- Disable health checks for these providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
