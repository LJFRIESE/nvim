
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

-- Global vars
vim.o.statuscolumn = '%!v:lua.get_statuscol()'
vim.g.have_nerd_font = true

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.o.rnu = true
vim.o.nu = true

vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0 --have cd follow browsing

-- ui
-- Show which line your cursor is on
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver100-Cursor,r-cr-o:hor100'
vim.opt.colorcolumn = { '88' }
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt_global.sidescroll = 20
vim.opt_global.scrolloff = 8

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Max n suggestions in popups
vim.opt.pumheight = 10

-- windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- whitespace
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true
vim.opt.smartindent = true

-- Enable break indent
vim.opt.wrap = false

-- Undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 250

-- Save undo history
vim.opt.undofile = true
vim.g.undotree_DiffCommand = 'FC'

-- Plugins

vim.opt.timeoutlen = 300-- Decrease mapped sequence wait time
vim.b.slime_cell_delimiter = '```'

-- matchpairs	list of pairs that match for the "%" command
-- 	(local to buffer)
--  	set mps=(:),{:},[:]

--         -- interesting idea to explore for formatting documentation
-- vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
--     contents = vim.lsp.util._normalize_markdown(contents, {
--         width = vim.lsp.util._make_floating_popup_size(contents, opts),
--     })
--     vim.bo[bufnr].filetype = 'markdown'
--     vim.treesitter.start(bufnr)
--     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
    --
    -- return contents
-- end
