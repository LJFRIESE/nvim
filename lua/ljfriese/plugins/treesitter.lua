return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    opts = {
        ensure_installed = { 'yaml', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'vim', 'vimdoc', 'sql', 'r', 'markdown', 'markdown_inline', 'rnoweb', 'sql' },
        -- auto_install = true,
        -- highlight = {
            --   additionalvim_regex_highlighting={enable=true}},
            indent = {enable = true},
            textobjects = {
            --enable=true,
                select = {
                    --enable=true,
                    lookahead=true,
                    keymaps = {
                        -- code block
                        ["ao"] = { query = {'@block.outer', '@conditional.outer', '@loop.outer' }},
                        ["io"] = { query = { '@block.inner', '@conditional.inner', '@loop.inner' }},
                        -- f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- func
                        -- c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
                        -- t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
                        -- d = { '%f[%d]%d+' }, -- digits
                        -- e = { -- Word with case
                            --   { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
                            --   '^().*()$',
                            -- },
                            -- -- i = LazyVim.mini.ai_indent, -- indent
                            -- -- g = LazyVim.mini.ai_buffer, -- buffer
                            -- u = ai.gen_spec.function_call(), -- u for "Usage"
                            -- U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in  name
                        },
                    },
                },
            },
            config = function(_, opts)
                require('nvim-treesitter.install').prefer_git = true
                ---@diagnostic disable-next-line: missing-fields
                require('nvim-treesitter.configs').setup(opts)

                require('treesitter-context').setup({
                    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                    line_numbers = true,
                    multiline_threshold = 20, -- Maximum number of lines to show for a single context
                    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                    mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
                    separator = '-',
                    zindex = 20, -- The Z-index of the context window
                    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
                })

            end,
        }
