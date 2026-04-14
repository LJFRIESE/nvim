vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('ljfriese/pack', {}),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
-- If don't do this on `FileType`, this keeps reappearing due to being set in
-- filetype plugins.
-- Use 'q' to close special buffer types. '' catches a lot of transient plugin windows.
vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('ljfriese/close_with_q', {}),
    desc = 'Close with <q>',
    pattern = {
        '',
        'help',
        'fugitive',
        'checkhealth',
        'vim',
        'git',
        'help',
        'man',
        'qf',
        'scratch',
    },
    callback = function(args)
        if args.match ~= 'help' or not vim.bo[args.buf].modifiable then
            vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
        end
    end,
})

-- This was something about plugins/ftplugin files overwriting things... Necessary?
--vim.api.nvim_create_autocmd('FileType', {
--    group = vim.api.nvim_create_augroup('ljfriese/formatting', {}),
--    pattern = '*',
--    callback = function()
--        vim.cmd('setlocal formatoptions-=c formatoptions-=o')
--    end,
--    desc = [[Ensure proper 'formatoptions']],
--})

-- Search for word under cursor
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    desc = 'Search word under cursor',
    group = vim.api.nvim_create_augroup('ljfriese/yanking', {}),
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('ljfriese/last_location', {}),
    desc = 'Go to the last location when opening a buffer',
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd 'normal! g`"zz'
        end
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('ljfriese/yanking', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 100,
        })
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('ljfriese/lsp', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end,
})


vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('ljfriese/lsp', {}),
    callback = function(ev)
        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        vim.notify(vim.lsp.status(), 'info', {
            id = 'lsp_progress',
            title = 'LSP Progress',
            opts = function(notif)
                notif.icon = ev.data.params.value.kind == 'end' and ' ' or
                    spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})

--- Center when inserting
vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('ljfriese/insert', {}),
    callback = function()
        local debounce = 8
        if vim.fn.abs(vim.fn.line('.') - math.floor(vim.fn.line('w0') + vim.fn.winheight(0) / 2)) >= debounce then
            vim.cmd('norm! zz')
        end
    end,
})


