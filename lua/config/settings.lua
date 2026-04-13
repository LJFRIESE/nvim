vim.g.projects_dir = vim.env.HOME .. '/projects'
vim.g.mapleader = ' '

-- Folding =====================================================================
vim.o.foldlevelstart=99
vim.o.foldenable = true
vim.o.foldmethod = 'expr'                          -- Folding lsp
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Default to treesitter folding

vim.o.foldcolumn = "0"
vim.opt.foldtext = "v:lua.custom_foldtext()"
vim.opt.fillchars:append({ foldclose = '', fold = " " })

local function fold_virt_text(result, s, lnum, coloff)
    if not coloff then
        coloff = 0
    end
    local text = ""
    local hl
    for i = 1, #s do
        local char = s:sub(i, i)
        local hls = vim.treesitter.get_captures_at_pos(0, lnum - 1, coloff + i - 1)
        local _hl = hls[#hls]
        if _hl then
            local new_hl = "@" .. _hl.capture
            if new_hl ~= hl then
                table.insert(result, { text, hl })
                text = ""
                hl = nil
            end
            text = text .. char
            hl = new_hl
        else
            text = text .. char
        end
    end
    table.insert(result, { text, hl })
end

function _G.custom_foldtext()
    local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
    local n_lines = vim.v.foldend - vim.v.foldstart
    local result = {}
    fold_virt_text(result, start, vim.v.foldstart)
    table.insert(result, { "  " .. n_lines, "Special" })
    return result
end

-- General ====================================================================

vim.opt.winborder = 'rounded'
vim.opt.autoread  = true  -- sync buffers automatically
vim.opt.backup    = false -- Don't store backup
vim.opt.clipboard = 'unnamedplus'
vim.opt.isfname:append('@-@')
vim.opt.mouse       = 'a'            -- Enable mouse
vim.opt.mousescroll = 'ver:25,hor:6' -- Customize mouse scroll
vim.opt.switchbuf   = 'usetab'       -- Use already opened buffers when switching
vim.opt.jumpoptions = "stack,view"   -- Treat jumplist like a tag stack and restor view
vim.opt.swapfile    = false          -- disable neovim generating a swapfile and showing the error
vim.opt.timeoutlen  = 300            -- Decrease mapped sequence wait time
vim.opt.undofile    = true           -- Enable persistent undo

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
    virtual_lines = false,
    jump = {
        wrap = true,
        float = true
    },
})

-- UI =========================================================================
vim.g.have_nerd_font  = true
vim.opt.termguicolors = true

vim.opt.cursorline    = true
vim.opt.cursorlineopt = 'screenline,number'  -- Show cursor line only screen line when wrapped
vim.opt.guicursor     = 'n-sm:block-Cursor,i-t:ver30-iCursor,v:block-vCursor,r-c:block-cCursor,o:block-oCursor'

vim.opt.diffopt       = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"

vim.opt.statuscolumn  = '%l%s'
vim.opt.signcolumn    = 'yes:1'
vim.opt.colorcolumn   = '+1'  -- Highlight after textwidth
vim.o.wrap            = false
vim.api.nvim_set_option_value('wrap', wide_enough, {})
vim.opt.breakindentopt = 'list:-1' -- Add padding for lists when 'wrap' is on
vim.opt.rnu            = true
vim.opt.number         = true
vim.opt.textwidth      = 88

vim.opt.hlsearch       = true
vim.opt.incsearch      = true
vim.opt.inccommand     = 'split' -- Preview substitutions live

vim.opt.ignorecase     = true    -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch      = true    -- Show search results while typing

vim.opt.sidescroll     = 20
vim.opt.scrolloff      = 8

vim.opt.splitright     = true
vim.opt.splitbelow     = true

-- Editing ====================================================================
vim.opt.iskeyword:append('-') -- Treat dash separated words as a word text object-
vim.opt.infercase     = true  -- Infer letter cases for a richer built-in keyword completion

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list item'
vim.opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.opt.tabstop       = 4
vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4

vim.opt.autoindent    = true
vim.opt.smartindent   = true
vim.opt.expandtab     = true
vim.opt.formatoptions = 'tcrqnl1j' -- Improve comment editing. Trust me.

-- Spelling ===================================================================
vim.opt.spelllang     = 'en,uk'                                        -- Define spelling dictionaries
vim.opt.spelloptions  = 'camel'                                        -- Treat parts of camelCase words as seprate words
vim.opt.complete:append('kspell')                                      -- Add spellcheck options for autocomplete
vim.opt.complete:remove('t')                                           -- Don't use tags for completion

vim.opt.dictionary = vim.fn.stdpath('config') .. '/spell/en.utf-8.spl' -- Use specific dictionaries

--- Disable health checks for these providers.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
