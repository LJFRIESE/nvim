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
                format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
            },
        },
    }
)
