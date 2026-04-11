local schema_db = vim.fn.stdpath('data') .. '/oracle_schema.db'

vim.cmd('DB sqlite:' .. schema_db)

vim.cmd('DBUIFindBuffer')
