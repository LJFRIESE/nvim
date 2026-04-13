vim.cmd.colorscheme('rose-akai')
vim.g.mapleader = ' '

function IsWindows()
    if vim.uv.os_uname().sysname == "Windows_NT" then
        return true
    end
end

-- Used with some plugins like Snacks, because they don't get along well with whickey
MapKeys = function(keys)
    for _, map in ipairs(keys) do
        local opts = { desc = map.desc }
        if map.silent ~= nil then
            opts.silent = map.silent
        end
        if map.noremap ~= nil then
            opts.noremap = map.noremap
        else
            opts.noremap = true
        end
        if map.expr ~= nil then
            opts.expr = map.expr
        end

        local mode = map.mode or "n"
        vim.keymap.set(mode, map[1], map[2], opts)
    end
end



require("config.settings")
require("config.autocmds")

require("plugins.dadbod")
require("plugins.blink")

require("plugins.snacks")
require("plugins.oil")
require("plugins.conform")
require("plugins.mini")
require("plugins.misc")
require("plugins.which-key")

require("config.keymaps")



-- LSP ===========================================================================
vim.lsp.config('*', {
  root_markers = { '.git' }, -- Set default root marker for all clients
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})
--
vim.lsp.enable('sqls')
vim.lsp.enable('luals')
-- vim.lsp.enable('gopls')
vim.lsp.enable('marksman')
-- vim.lsp.enable('ahk')
