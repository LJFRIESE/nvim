vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim",
    } })
local wk = require("which-key")

wk.setup({
	preset = "helix",
})

wk.add({
    { 'g', desc = '[G]o ...' },
    { 'gc', group = '[C]omment' },
    { '<leader>d', desc = '[D]ebug ...' },
    { '<leader>c', group = '[C]ompile ...' },
    { '<leader>s', group = '[S]earch ...', icon = '' },
    { '<leader>f', group = '[F]ind ...', icon = '' },
    { '<leader>g', group = '[G]it' },
    { '<leader>gt', group = '[T]oggle ...' },
    { '<leader>b', group = '[B]uffer' },
    { '<leader>r', group = '[R]egex replace' },
    { '<leader>o', group = 'Insert linebreak ...' },
})




-- require("which-key").setup({
--         delay = 200,
--         preset = 'helix',
--         -- expand = -1,
--         sort = { 'alphanum', 'group', 'local', 'order', 'mod' },
--             presets = {
--                 operators = true, -- adds help for operators like d, y, ...
--                 motions = false, -- adds help for motions
--                 text_objects = true, -- help for text objects triggered after entering an operator
--                 windows = true, -- default bindings on <c-w>
--                 nav = true,    -- misc bindings to work with windows
--                 z = true,      -- bindings for folds, spelling and others prefixed with z
--                 g = true,      -- bindings for prefixed with g,
--     }
-- })
