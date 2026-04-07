-- sqls = {
--   cmd = { 'sqls', '-config', 'config.yml' },
--   server_capabilities = {
--     documentFormattingProvider = false,
--   },
-- },
return {
    cmd = { 'sqls' },
    filetypes = { 'sql' },
    root_markers = { '.git' },
    settings = { lowercaseKeywords = false },
}
