vim.pack.add({
    { src='https://github.com/kristijanhusak/vim-dadbod-ui' },
    {src= 'https://github.com/tpope/vim-dadbod' },
    { src='https://github.com/kristijanhusak/vim-dadbod-completion' },
})

vim.g.dbs = {
    { name = 'SQLITE', url = "sqlite:" .. vim.fn.stdpath('data') .. '/oracle_schema.db' },
}


--
-- require('dadbod-ui').init({
--     cmd = {
--         'DBUI',
--         'DBUIToggle',
--         'DBUIAddConnection',
--         'DBUIFindBuffer',
--     },
--     init = function()
--         -- Your DBUI configuration
--         vim.g.db_ui_use_nerd_fonts = 1
--     end,
-- }
-- )
