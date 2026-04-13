vim.pack.add({ {
    src = 'https://github.com/folke/trouble.nvim' } })

require("trouble").setup({
    opts = {
        warn_no_results = true, -- show a warning when there are no results
        open_no_results = true, -- open the trouble window when there are no results
        auto_close = true,
        auto_jump = true,
    },
})

-- Open trouble when quickfix is opened
-- add cmd :ccl to also auto-close the qf buf. Not sure if I want to yet...
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    callback = function()
        vim.cmd([[Trouble qflist open]])
        vim.cmd([[ccl]])
    end,
})




local keys = {
    {
        ']t',
        function()
            if require('trouble').is_open() then
                require('trouble').next({ skip_groups = true, jump = true })
            else
                local ok, err = pcall(vim.diagnostic.get_next)
                if not ok then
                    ---@diagnostic disable-next-line
                    vim.notify(err, vim.log.levels.ERROR)
                end
            end
        end,
        desc = 'Jump to next error',
    },
    {
        '[t',
        function()
            if require('trouble').is_open() then
                require('trouble').prev({ skip_groups = true, jump = true })
            else
                local ok, err = pcall(vim.diagnostic.get_prev)
                if not ok then
                    ---@diagnostic disable-next-line
                    vim.notify(err, vim.log.levels.ERROR)
                end
            end
        end,
        desc = 'Jump to prev error',
    },
    {
        'tt',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = '[T]rouble Diagnostics',
    },
    {
        'tb',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = '[B]uffer Diagnostics',
    },
    {
        'ts',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = '[S]ymbols (Trouble)',
    },
    {
        'td',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = '[D]efinitions / references',
    },
    {
        'tl',
        '<cmd>Trouble loclist toggle<cr>',
        desc = '[L]ocation List',
    },
    {
        'tq',
        '<cmd>Trouble qflist toggle<cr>',
        desc = '[Q]uickfix List',


    }, }


MapKeys(keys)
