vim.pack.add({
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/mikavilpas/blink-ripgrep.nvim', },
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = 'v1.10.2',
    },
})

require("blink.cmp").setup({
    sources = {
        default = { 'lsp', 'path', 'buffer', 'ripgrep', 'snippets' },
        providers = {
            lsp = {},
            path = { opts = { show_hidden_files_by_default = true } },
            ripgrep = { max_items = 3, score_offset = -2, module = 'blink-ripgrep', name = 'ripgrep'
            },
            dadbod = {
                name = "Dadbod",
                module = "vim_dadbod_completion.blink"
            },
        },
        per_filetype = {
            sql = { "lsp", "dadbod", "snippets" },
        },
    },
    keymap = {
        preset = "none",
        ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    cmdline = {
        keymap = { preset = 'inherit' },
        completion = { menu = { auto_show = true } },
    },
    completion = {
        documentation = {
            auto_show = true,
            window = {
                border = 'rounded',
                max_height = 100
            },
        },
        menu = { border = 'rounded', },
    },
    signature = {
        enabled = true,
        window = { border = 'rounded' },
    },
})

-- buffer = {
--     opts = {
--         -- or (recommended) filter to only "normal" buffers
--         get_bufnrs = function()
--             return vim.tbl_filter(function(bufnr)
--                 return
--                     vim.bo[bufnr].buftype == ''
--             end, vim.api.nvim_list_bufs())
--         end
--     }
-- },
--
