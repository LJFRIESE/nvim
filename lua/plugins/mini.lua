vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.ai' },
    { src = 'https://github.com/echasnovski/mini.sessions' },
    { src = 'https://github.com/echasnovski/mini.misc' },
    { src = 'https://github.com/echasnovski/mini.surround' },
    { src = 'https://github.com/echasnovski/mini.statusline' } })

require('mini.misc').setup()
require('mini.misc').setup_auto_root()

require('mini.sessions').setup({ autoread = true, autowrite = true })

require('mini.surround').setup({
    opts = {
        highlight_duration = 500,
        n_lines = 100,
        respect_selection_type = false,
        search_method = 'cover',
        silent = false,
    }
}
)

require('mini.ai').setup({
    silent = true,
    n_lines = 500,
    custom_textobjects = {
        -- whole buffer
        g = function()
            local from = { line = 1, col = 1 }
            local to = {
                line = vim.fn.line('$'),
                col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
        end,
        f = require('mini.ai').gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@comment', i = '@comment' }), -- comment
        d = { '%f[%d]%d+' },                                                            -- digits
    },
})

require('mini.statusline').setup({
    use_icons = vim.g.have_nerd_font,
    content = {
        active = function()
            local MiniStatusline = require('mini.statusline')
            local get_session = function()
                if vim.v.this_session ~= '' then
                    return vim.fs.basename(vim.v.this_session)
                else
                    return 'No Active Session'
                end
            end

            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 20 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                 strings = { mode } },
                { hl = 'MiniStatuslineDevinfo', strings = {} },
                '%<%=', -- truncate point
                { hl = 'MiniStatuslineFileInfo', strings = { '%t' .. ' | ' .. get_session() } },
                '%=',   -- End left alignment
                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, '%2l:%-2L' } },
            })
        end,
    }
})
