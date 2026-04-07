
vim.pack.add( {
   {src = 'https://github.com/rafamadriz/friendly-snippets'},
   {src = 'https://github.com/mikavilpas/blink-ripgrep.nvim',
   version = vim.version.range('*')},
   {src = 'https://github.com/saghen/blink.cmp',
   version = vim.version.range('*') ,
    data = {
            opts = {
                sources = {
                    default = {
                        'lsp',
                        'buffer',
                        'ripgrep',
                        'snippets',
                        'lazydev',
                    },
                    providers = {
                        lsp = {fallbacks = {}},
                        ripgrep = { max_items = 3, score_offset = -2, module = 'blink-ripgrep', name = 'ripgrep' },
                        buffer = {
                            opts = {
                                -- or (recommended) filter to only "normal" buffers
                                get_bufnrs = function()
                                    return vim.tbl_filter(function(bufnr)
                                        return vim.bo[bufnr].buftype == ''
                                    end, vim.api.nvim_list_bufs())
                                end
                            }
                        },
                        lazydev = {
                            module = 'lazydev.integrations.blink',
                            score_offset = 100,
                        },
                        path = { opts = { show_hidden_files_by_default = true } },
                    },
                },
                keymap = {
                    preset = 'super-tab',
                    ['<C-.>'] = { 'show', 'show_documentation', 'hide_documentation' },
                    ['<C-y>'] = { 'select_and_accept' },
                },
                completion = {
                    documentation = {
                        window = {
                            -- border = 'rounded',
                            max_height = 100
                        },
                    },
                    menu = {
                        draw = {
                            columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
                            treesitter = { 'lsp' },
                        },
                        -- border = 'rounded',
                    },
                },
                signature = {
                    enabled = true,
                    -- window = { border = 'rounded' },
                },
            },
            opts_extend = { 'sources.default' },
            min_keyword_length = 0,
        }
   }
}
)




require("blink.cmp").setup()
