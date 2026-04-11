-- very clean snacks
-- https://tduyng.com/blog/vim-pack-and-snacks/#setting-up-which-keynvim

vim.pack.add({ { src = "https://github.com/folke/snacks.nvim", } })

require("snacks").setup({
    quickfile = {},
    picker = { enabled = true, lazygit = true, terminal = true },
    notifier = {},
    -- words = {},
    indent = {
        animate = { duration = { steps = 5, total = 50 } }
    }
})

local Snacks = require("snacks")
-- Snacks.picker
local keys = {
    { "<leader>gg",       function() Snacks.lazygit() end,                                         desc = "Lazygit" },
    { "<leader>/",        function() Snacks.picker.grep() end,                                     desc = "Grep" },
    { "<leader>:",        function() Snacks.picker.command_history() end,                          desc = "Command History" },
    -- find
    { "<leader><leader>", function() Snacks.picker.buffers() end,                                  desc = "Buffers" },
    { "<leader>fn",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), }) end, desc = "Find Config File" },
    { "<leader>ff",       function() Snacks.picker.files() end,                                    desc = "Find Files" },
    { "<leader>fg",       function() Snacks.picker.git_files() end,                                desc = "Find Git Files" },
    { "<leader>fr",       function() Snacks.picker.recent() end,                                   desc = "Recent" },
    { "<leader>fp",       function() Snacks.picker.projects() end,                                 desc = "[P]rojects" },
    -- git
    { "<leader>gc",       function() Snacks.picker.git_log() end,                                  desc = "Git Log" },
    { "<leader>gs",       function() Snacks.picker.git_status() end,                               desc = "Git Status" },
    -- Grep
    { "<leader>sb",       function() Snacks.picker.lines() end,                                    desc = "Buffer Lines" },
    { "<leader>sB",       function() Snacks.picker.grep_buffers() end,                             desc = "Grep Open Buffers" },
    { "<leader>sw",       function() Snacks.picker.grep_word() end,                                desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"',       function() Snacks.picker.registers() end,                                desc = "Registers" },
    { "<leader>sa",       function() Snacks.picker.autocmds() end,                                 desc = "Autocmds" },
    { "<leader>sc",       function() Snacks.picker.command_history() end,                          desc = "Command History" },
    { "<leader>sC",       function() Snacks.picker.commands() end,                                 desc = "Commands" },
    { "<leader>sd",       function() Snacks.picker.diagnostics() end,                              desc = "Diagnostics" },
    { "<leader>sh",       function() Snacks.picker.help() end,                                     desc = "Help Pages" },
    { "<leader>sH",       function() Snacks.picker.highlights() end,                               desc = "Highlights" },
    { "<leader>sj",       function() Snacks.picker.jumps() end,                                    desc = "Jumps" },
    { "<leader>sk",       function() Snacks.picker.keymaps() end,                                  desc = "Keymaps" },
    { "<leader>sl",       function() Snacks.picker.loclist() end,                                  desc = "Location List" },
    { "<leader>sM",       function() Snacks.picker.man() end,                                      desc = "Man Pages" },
    { "<leader>sm",       function() Snacks.picker.marks() end,                                    desc = "Marks" },
    { "<leader>sa",       function() Snacks.picker.resume() end,                                   desc = "[A]gain" },
    { "<leader>sq",       function() Snacks.picker.qflist() end,                                   desc = "[Q]uickfix List" },
    { "<leader>sC",       function() Snacks.picker.colorschemes() end,                             desc = "Colorschemes" },
    -- LSP
    { "grd",              function() Snacks.picker.lsp_definitions() end,                          desc = "Goto Definition" },
    { "grr",              function() Snacks.picker.lsp_references() end,                           nowait = true,                     desc = "References" },
    { "gri",              function() Snacks.picker.lsp_implementations() end,                      desc = "Goto Implementation" },
    { "grt",              function() Snacks.picker.lsp_type_definitions() end,                     desc = "Goto T[y]pe Definition" },
    { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                              desc = "LSP Symbols" },
}

MapKeys(keys)
