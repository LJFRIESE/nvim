-- file explore
-- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
-- auto-closing them after leaving insert mode, however ufo does not seem to
-- have equivalents for zr and zm because there is no saved fold level.
-- Consequently, the vim-internal fold levels need to be disabled by setting
-- them to 99.
-- vim.opt.foldlevel = 99
-- vim.opt.foldlevelstart = 99
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

-- Stolen from Akinsho
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

vim.o.statuscolumn = '%!v:lua.get_statuscol()'

vim.o.rnu = true
vim.o.nu = true

vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0 --have cd follow browsing

-- ui
vim.opt.guicursor = ''

vim.opt.colorcolumn = { '80' }
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- undotree for ewindows:q

vim.g.undotree_DiffCommand = 'FC'

vim.b.slime_cell_delimiter = '```'
vim.opt.termguicolors = true
