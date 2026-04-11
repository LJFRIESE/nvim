
return {
    cmd = { 'sqls', '-config', vim.fn.expand('~/.sqls/config.yml') },
    filetypes = { 'sql', 'mysql' },
    root_markers = {  '.git' },
    settings = { lowercaseKeywords = false },
}

-- SQL LSP: using ~/.sqls/config.yml for connection settings

