vim.pack.add({ { src = 'https://github.com/rafamadriz/friendly-snippets' }, {
    src = 'https://github.com/mikavilpas/blink-ripgrep.nvim',
},
    { src = 'https://github.com/saghen/blink.cmp' },
})

require("blink.cmp").setup({
    sources = {
        default = { 'lsp', 'path',
            'buffer', 'ripgrep', 'snippets' },
        providers = {
            lsp = {},
            ripgrep = { max_items = 3, score_offset = -2, module = 'blink-ripgrep', name = 'ripgrep'
            },
            buffer = {
                opts = {
                    -- or (recommended) filter to only "normal" buffers
                    get_bufnrs = function()
                        return vim.tbl_filter(function(bufnr)
                            return
                                vim.bo[bufnr].buftype == ''
                        end, vim.api.nvim_list_bufs())
                    end
                }
            },
            path = {
                opts
                = { show_hidden_files_by_default = true }
            },
            dadbod = {
                name = "Dadbod",
                module = "vim_dadbod_completion.blink"
            },
        },
        per_filetype = {
            sql = { "lsp", "dadbod", "snippets", "buffer" },
        },
    },
    keymap = {
        preset
                  = 'super-tab',
        ['<C-k>'] = { 'show_signature', 'show_documentation', 'hide_documentation'
        },
        ['<C-y>'] = { 'select_and_accept' },
    },
    completion = {
        documentation = {
            window
                     = {
                -- border = 'rounded',
                max_height = 100
            },
        },
        menu = {
            draw = {
                columns = { { 'kind_icon' }, {
                    'label',
                    'label_description',
                    gap = 1
                }, { 'source_name' } },
                treesitter = { 'lsp' },
            },
            -- border = 'rounded',
        },
    },
    signature = {
        enabled = true,
        -- window = { border = 'rounded' },
    },
})

