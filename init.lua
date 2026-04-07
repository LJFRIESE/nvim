vim.cmd.colorscheme('rose-akai')
vim.g.mapleader = ' '

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

function IsWindows()
    if vim.uv.os_uname().sysname == "Windows_NT" then
        return true
    end
end

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

require("plugins.snacks")
require("plugins.oil")
require("plugins.conform")
require("plugins.mini")
require("plugins.misc")
require("plugins.which-key")

require("config.keymaps")
require("config.autocmds")
require("config.settings")
