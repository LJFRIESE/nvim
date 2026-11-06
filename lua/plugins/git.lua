vim.pack.add({
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
})

require('gitsigns').setup({
    signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between hunks
        map('n', ']h', function()
            if vim.wo.diff then
                return ']c'
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, desc = 'Next [H]unk' })

        map('n', '[h', function()
            if vim.wo.diff then
                return '[c'
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return '<Ignore>'
        end, { expr = true, desc = 'Prev [H]unk' })

        -- Actions
        map('n', '<leader>ghs', gs.stage_hunk, { desc = '[S]tage hunk' })
        map('n', '<leader>ghr', gs.reset_hunk, { desc = '[R]eset hunk' })
        map('v', '<leader>ghs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = '[S]tage hunk' })
        map('v', '<leader>ghr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, { desc = '[R]eset hunk' })
        map('n', '<leader>ghS', gs.stage_buffer, { desc = '[S]tage buffer' })
        map('n', '<leader>ghR', gs.reset_buffer, { desc = '[R]eset buffer' })
        map('n', '<leader>ghp', gs.preview_hunk, { desc = '[P]review hunk' })
        map('n', '<leader>ghb', function()
            gs.blame_line({ full = true })
        end, { desc = '[B]lame line' })
        map('n', '<leader>ghd', gs.diffthis, { desc = '[D]iff this' })
        map('n', '<leader>ghD', function()
            gs.diffthis('~')
        end, { desc = '[D]iff this ~' })
        map('n', '<leader>ght', gs.toggle_deleted, { desc = '[T]oggle deleted' })
    end,
})