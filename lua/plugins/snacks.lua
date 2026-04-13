-- very clean snacks
-- https://tduyng.com/blog/vim-pack-and-snacks/#setting-up-which-keynvim

vim.pack.add({ { src = "https://github.com/folke/snacks.nvim", } })

require("snacks").setup({
    quickfile = {},
    picker = {
        enabled = true,
        lazygit = true,
        terminal = true,
        sources = {
            marks = {},
            notifier = {},
            -- words = {},
            --
        }
    },
    indent = {
        animate = { duration = { steps = 5, total = 50 } } }
})

local Snacks = require("snacks")
-- Snacks.picker
local keys = {
    { "<leader>:",        function() Snacks.picker.command_history() end,                          desc = "Command History" },
    -- find
    { "<leader>fb",       function() Snacks.picker.buffers() end,                                  desc = "Buffers" },
    { "<leader>fn",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), }) end, desc = "Find Config File" },
    { "<leader>ff",       function() Snacks.picker.files() end,                                    desc = "Find Files" },
    { "<leader>fg",       function() Snacks.picker.git_files() end,                                desc = "Find Git Files" },
    { "<leader>fr",       function() Snacks.picker.recent() end,                                   desc = "Recent" },
    { "<leader>fp",       function() Snacks.picker.projects() end,                                 desc = "[P]rojects" },
    -- git
    { "<leader>gg",       function() Snacks.lazygit() end,                                         desc = "Lazygit" },
    { "<leader>gc",       function() Snacks.picker.git_log() end,                                  desc = "Git Log" },
    { "<leader>gs",       function() Snacks.picker.git_status() end,                               desc = "Git Status" },
    -- Grep
    { "<leader>/",        function() Snacks.picker.grep() end,                                     desc = "Grep" },
    { "<leader>sb",       function() Snacks.picker.lines() end,                                    desc = "Buffer Lines" },
    { "<leader>sB",       function() Snacks.picker.grep_buffers() end,                             desc = "Grep Open Buffers" },
    { "<leader>sw",       function() Snacks.picker.grep_word() end,                                desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"',       function() Snacks.picker.registers() end,                                desc = "Registers" },
    { "<leader><leader>", function() Snacks.picker.autocmds() end,                                 desc = "Autocmds" },
    { "<leader>sc",       function() Snacks.picker.command_history() end,                          desc = "Command History" },
    { "<leader>sC",       function() Snacks.picker.commands() end,                                 desc = "Commands" },
    { "<leader>sd",       function() Snacks.picker.diagnostics() end,                              desc = "Diagnostics" },
    { "<leader>sD",       function() Snacks.picker.diagnostics_buffer() end,                       desc = "Buffer Diagnostics" },
    { "<leader>sh",       function() Snacks.picker.help() end,                                     desc = "Help Pages" },
    { "<leader>sH",       function() Snacks.picker.highlights() end,                               desc = "Highlights" },
    { "<leader>sj",       function() Snacks.picker.jumps() end,                                    desc = "Jumps" },
    {
        "<leader>sk",
        function() Snacks.picker.keymaps() end,
        desc = "Keymaps"
    }, {
    "<leader>sl",
    function()
        Snacks.picker.loclist()
    end,
    desc
    = "Location List"
},
    { "<leader>sM", function() Snacks.picker.man() end,     desc = "Man Pages" },
    { "<leader>sm", function() Snacks.picker.marks({}) end, desc = "Search marks" },
    {
        "<leader>mm",
        function()
            Snacks.picker.marks({
                layout = {
                    layout = {
                        backdrop = false,
                        width = 0.5,
                        max_width = 80,
                        height = 0.4,
                        min_height = 3,
                        box = "horizontal",
                        border = "none",
                        title = "{title}",
                        title_pos = "center",
                        { win = "list",    title = "Marks",     border = "rounded" },
                        { win = "preview", title = "{preview}", width = 0.6,       border = "rounded" },
                    },
                },
                actions = {
                    delmark = function(picker)
                        local selected = picker:selected { fallback = true }
                        local to_delete = vim
                            .iter(selected)
                            :map(function(it)
                                return it.label
                            end)
                            :join ''
                        vim.api.nvim_win_call(vim.fn.win_getid(vim.fn.winnr '#'), function()
                            if pcall(vim.cmd.delmark, to_delete) then
                                -- NOTE: Before `picker.list:set_target`
                                -- NOTE: Resets `picker.list:is_selected`, `picker.list.selected`
                                picker.list:set_selected()
                                picker.list:set_target(math.min(picker.list.cursor, picker:count() - #selected))
                                picker:find() -- NOTE: Should also be called inside `nvim_win_cal`
                            else
                                Snacks.notify.error(string.format('Unable to delete marks: %s', to_delete))
                            end
                        end)
                    end,
                },
                win = {
                    list = {
                        keys = {
                            ['J'] = { 'delmark', mode = { 'v' } },
                            ['K'] = { 'delmark', mode = { 'v' } },
                            ['x'] = 'delmark',
                        },
                    }
                },
                transform = function(item)
                    if item.label and item.label:match("^[A-I]$") and item then
                        -- item.label = "" .. string.byte(item.label) - string.byte("A") + 1 .. ""
                        item.file = vim.fn.fnamemodify(item.file, ':t')
                        return item
                    end
                    return false
                end,
            })
        end,
        desc = "Marks"
    },
    { "<leader>sa", function() Snacks.picker.resume() end,                desc = "[A]gain" },
    { "<leader>sq", function() Snacks.picker.qflist() end,                desc = "[Q]uickfix List" },
    { "<leader>su", function() Snacks.picker.undo() end,                  desc = "Undo History" },
    { "<leader>sC", function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
    -- LSP
    { "gd",         function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,        nowait = true,                  desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
    { "gai",        function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
    { "gao",        function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
}
MapKeys(keys)
