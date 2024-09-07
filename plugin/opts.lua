
-- INFO: fold commands usually change the foldlevel, which fixes folds, e.g.
-- auto-closing them after leaving insert mode, however ufo does not seem to
-- have equivalents for zr and zm because there is no saved fold level.
-- Consequently, the vim-internal fold levels need to be disabled by setting
-- them to 99.
vim.opt.fillchars = {
  horiz = '─', horizup = '┴', horizdown = '┬', vert = '│', vertleft = '┤', vertright = '├', verthoriz = '┼', fold = ' ', foldopen = '⎧', foldclose = '', foldsep = '│',
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


-- General ====================================================================

vim.o.backup       = false          -- Don't store backup
vim.o.mouse        = 'a'            -- Enable mouse
vim.o.mousescroll  = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf    = 'usetab'       -- Use already opened buffers when switching
vim.o.timeoutlen = 300              -- Decrease mapped sequence wait time

vim.opt.clipboard = 'unnamedplus'

vim.o.undofile     = true           -- Enable persistent undo
vim.g.undotree_DiffCommand = 'FC'

vim.opt.isfname:append('@-@')

-- Plugins
vim.b.slime_cell_delimiter = '```' --move to quarto

-- netrw
vim.g.netrw_liststyle     = 3
vim.g.netrw_browse_split  = 0
vim.g.netrw_banner        = 0

-- UI =========================================================================
vim.g.have_nerd_font      = true
vim.opt.cursorline        = true
vim.opt.showmode          = false
vim.opt.termguicolors     = true

vim.opt.guicursor         = 'n-v-c-sm:block,i-ci-ve:ver100-Cursor,r-cr-o:hor100'
vim.opt.statuscolumn      = '%!v:lua.get_statuscol()'
vim.opt.textwidth         = 88
vim.opt.colorcolumn       = '+1'

vim.o.winblend      = 10        -- Make floating windows slightly transparentvim.o.wrap          = false     -- Display long lines as just one linevim.o.linebreak       = true   -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list            = true   -- Show helpful character indicators

vim.o.cursorlineopt   = 'screenline,number' -- Show cursor line only screen line when wrapped
vim.o.breakindentopt  = 'list:-1' -- Add padding for lists when 'wrap' is on
vim.opt.rnu           = true
vim.opt.number        = true
vim.opt.signcolumn    = 'yes'

vim.opt.hlsearch      = true
vim.opt.incsearch     = true
vim.opt.inccommand    = 'split' -- Preview substitutions live

vim.o.ignorecase      = true    -- Ignore case when searching (use `\C` to force not doing that)
vim.o.incsearch       = true  -- Show search results while typing

vim.opt_global.sidescroll = 20
vim.opt_global.scrolloff  = 8

vim.opt.pumheight         = 10    -- Max n suggestions in popups
vim.o.pumblend            = 10    -- Make builtin completion menus slightly transparent
--
-- windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Editing ====================================================================
vim.opt.iskeyword:append('-')  -- Treat dash separated words as a word text object-
-- Does this improve the SQL snippet cmp?
vim.o.infercase     = true     -- Infer letter cases for a richer built-in keyword completion

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- whitespace
vim.opt.tabstop     = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth  = 4

vim.o.autoindent    = true     -- Use auto indent
vim.o.smartindent   = true
vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing


-- Spelling ===================================================================
vim.o.spelllang    = 'en,ru,uk'   -- Define spelling dictionaries
vim.o.spelloptions = 'camel'      -- Treat parts of camelCase words as seprate words
vim.opt.complete:append('kspell') -- Add spellcheck options for autocomplete
vim.opt.complete:remove('t')      -- Don't use tags for completion

vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt' -- Use specific dictionaries

-- Custom autocommands ========================================================
local augroup = vim.api.nvim_create_augroup('CustomSettings', {})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  callback = function()
    -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
    -- If don't do this on `FileType`, this keeps reappearing due to being set in
    -- filetype plugins.
    vim.cmd('setlocal formatoptions-=c formatoptions-=o')
  end,
  desc = [[Ensure proper 'formatoptions']],
})


--- Disable health checks for these providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
