vim.pack.add( {
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        data = { opts = {
            ensure_installed = {
                'vimdoc',
                'toml',
                'go',
                'json',
                'diff',
                'html',
                'lua',
                'vimdoc',
                'sql',
                'r',
                'markdown',
                'markdown_inline',
                'sql',
            },
            auto_install = true,
            indent = { enable = true },
        },
    }
},
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-context',
        data = {opts = {
            enable = true,
            max_lines = 4,     -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 4, -- Maximum number of lines to show for a single context
            trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = 'topline',  -- Line used to calculate context. Choices: 'cursor', 'topline'
            separator = '-',
            zindex = 20,
        },
    }
},
    {
        src = 'https://github.com/Wansmer/treesj',
        data = {keys = { '<c-j>' },
        opts = function()
            require('treesj').setup({
                max_join_length = 240,
                use_default_keymaps = false,
            })
            vim.keymap.set(
                'n',
                '<c-j>',
                require('treesj').toggle,
                { desc = 'Toggle [j]oin node' }
            )
        end,
        },
    }
})

require('nvim-treesitter').setup()
require('treesitter-context').setup()
require('treesj').setup()

-- Toggle treesitter-context
vim.keymap.set('', '<leader>bc', function()
    local tsc = require('treesitter-context')
    if tsc.enabled() then
        tsc.disable()
    else
        tsc.enable()
    end
end, { desc = 'Toggle treesitter [c]ontext' })

