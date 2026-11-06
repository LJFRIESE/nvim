vim.pack.add({
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-context',
    },
    {
        src = 'https://github.com/Wansmer/treesj',
        data = {
            keys = { '<c-j>' },
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

-- Only auto-install parsers when the tree-sitter CLI is available.
if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install({
        'vimdoc',
        'toml',
        'go',
        'json',
        'diff',
        'html',
        'lua',
        'sql',
        'r',
        'markdown',
        'markdown_inline',
    })
end

require('treesitter-context').setup({
    enable = true,
    max_lines = 4,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 4,
    trim_scope = 'inner',
    mode = 'topline',
    separator = '-',
    zindex = 20,
})

-- Toggle treesitter-context
vim.keymap.set('', '<leader>bt', function()
    local tsc = require('treesitter-context')
    if tsc.enabled() then
        tsc.disable()
    else
        tsc.enable()
    end
end, { desc = 'Toggle treesitter con[t]ext' })

require('treesj').setup({
    use_default_keymaps = false,
})

vim.keymap.set('n', '<leader>j', require('treesj').toggle)

vim.keymap.set('n', '<leader>J', function()
    require('treesj').toggle({ split = { recursive = true } })
end)
