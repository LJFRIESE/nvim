-- Function to check for a tag and either jump to it or search in help
---@diagnostic disable-next-line
function help_lookup()
    local expr = vim.fn.expand('<cexpr>')
    ---@diagnostic disable-next-line
    local expr_ok = pcall(vim.cmd, 'help ' .. expr)
    if expr_ok then
        print('Help: ' .. expr)
        return
    end

    local word = vim.fn.expand('<cword>')
    ---@diagnostic disable-next-line
    local word_ok = pcall(vim.cmd, 'help ' .. word)
    if word_ok then
        print('Help: ' .. expr)
        return
    end
    vim.lsp.buf.hover()
    print('No entry: ' .. expr)
end

-- Manipulate text

-- Join line but keep cursor on mark
vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<leader>rg', [[:%s=\\>=<C-r><C-w>=gI<Left><Left><Left>]], { desc = '[g]lobal :s' })
vim.keymap.set('n', '<leader>rl', [[:s=\<<C-r><C-w>\>=<C-r><C-w>=gI<Left><Left><Left>]], { desc = '[l]ine :s' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

vim.keymap.set('v', '<', '<gv', { desc = 'Dedent while remaining in visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent while remaining in visual mode' })

-- Black whole this stuff
vim.keymap.set({ 'n', 'v' }, 'x', '"_d')
vim.keymap.set({ 'n', 'v' }, 'X', '"_D')
vim.keymap.set({ 'n', 'v' }, 'c', '"_c')
vim.keymap.set({ 'n', 'v' }, 'C', '"_C')

-- Match to non-nvim contexts
vim.keymap.set('i', '<C-H>', '<C-W>')

-- Diagnostic keymaps

vim.keymap.set('', '<leader>bl', function()
    vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
        virtual_text = not vim.diagnostic.config().virtual_text,
    })
end, { desc = 'Toggle diagnostic [l]ines' })


-- Toggle treesitter-context
vim.keymap.set('', '<leader>bc', function()
    local tsc = require('treesitter-context')
    if tsc.enabled() then
        tsc.disable()
    else
        tsc.enable()
    end
end, { desc = 'Toggle treesitter [c]ontext' })




vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = '[D]iagnostic' })
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = -1 })
end, { desc = '[D]iagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = '[d]iagnostics' })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '[q]uickfix list' })
vim.keymap.set('n', 'gcd', 'O---@diagnostic disable-next-line<esc>j', { desc = '[d]iagnostic disable' })

vim.keymap.set('n', 'gcl', 'A--no lint<esc>', { desc = '[l]int disable' })
vim.keymap.set('n', 'gw', '<cmd>Format<CR>', { desc = 'Format' })

-- Window navigation
vim.keymap.set('n', '<c-w>_', '<c-w>v', { desc = 'Virtical split' })
vim.keymap.set('n', '<c-w>-', '<c-w>s', { desc = 'Horizontal split' })

-- Misc
vim.keymap.set('n', '<c-u>', 'zz<c-u>', { desc = 'Center on jump' })
vim.keymap.set('n', '<c-d>', 'zz<c-d>', { desc = 'Center on jump' })

vim.keymap.set('n', '<leader>bd', ':%bdelete|edit #|normal`"', { desc = 'Delete all other buffers' })
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<CR>', { desc = 'Kill search highlight' })
vim.keymap.set('n', '<leader>t', function()
    require('custom.floaterminal').toggle_terminal()
end, { desc = '[T]erminal' })

vim.keymap.set('t', '<c-c><c-c>', '<c-\\><c-n>', { desc = 'Enter normal mode from Terminal' })

vim.keymap.set('n', '<leader>i', ':Inspect<CR>', { desc = '[I]nspect' })
vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = '[L]ine' })

vim.api.nvim_set_keymap('n', '<C-k>', ':lua help_lookup()<CR>', { noremap = true, silent = true })

-- Make U opposite to u.
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set('n', "<leader>U", function() require('undotree').toggle() end, { desc = '[u]ndo tree' })

-- vim.keymap.set('n', '<esc><esc>', '<cmd>ccl<CR>', { desc = 'Close quick fix window' })
vim.keymap.set('n', '<leader>C', function()
    require('nvim-highlight-colors').toggle()
end, { desc = 'Toggle [c]olours' })

-- Open Oil
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- stylua: ignore end
