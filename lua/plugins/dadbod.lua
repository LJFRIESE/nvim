vim.pack.add({
    { src = 'https://github.com/kristijanhusak/vim-dadbod-ui' },
    { src = 'https://github.com/tpope/vim-dadbod' },
    { src = 'https://github.com/kristijanhusak/vim-dadbod-completion' },
})

vim.g.dbs = {
    -- { name = 'CJBMIS',     url = '' },
    -- { name = 'BCPSBIAUTO', url = '' },
    -- { name = 'A193254',    url = '' },
    -- { name = 'SQLITE',     url = "sqlite:" .. vim.fn.stdpath('data') .. '/oracle_schema.db' }
}


vim.g.db_ui_save_location = 'X://Lucas F/db_ui/'
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_debug = 1
vim.g.db_ui_use_nvim_notify = 1
