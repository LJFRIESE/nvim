vim.pack.add({ { src = 'https://github.com/stevearc/conform.nvim',
} })

require('conform').setup({
    opts = {
        -- log_level = vim.log.levels.DEBUG,
        notify_on_error = true,
        formatters_by_ft = {
            json = { 'prettierd' },
            default_format_opts = {
                lsp_format = 'fallback',
            },
        },
    },
}
)
-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})

vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end

    require('conform').format({ async = true, lsp_format = 'fallback', range = range }, function(err, did_edit)
        if not err and did_edit then
            vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
        end
    end)
end, { range = true })

-- Format command
vim.keymap.set('n', 'gw', '<cmd>Format<CR><cmd>Lint<CR>', { desc = 'Format buffer' })
