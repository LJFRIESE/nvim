vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/sindrets/diffview.nvim' },
    { src = 'https://github.com/NeogitOrg/neogit' },
})

-- Git for Windows is preferred: MSYS/Cygwin git returns POSIX paths like
-- /c/Users/..., which Neovim's jobstart rejects as an invalid cwd on Windows.
local git_executable = 'git'
if vim.fn.has('win32') == 1 then
    local windows_git = 'C:/Program Files/Git/cmd/git.exe'
    if vim.fn.executable(windows_git) == 1 then
        git_executable = windows_git
    end
end

local neogit = require('neogit')

neogit.setup({
    git_executable = git_executable,
    integrations = { diffview = true },
})

local function run_git(args, success_message)
    local cmd = vim.list_extend({ git_executable }, args)

    vim.system(cmd, { text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.notify(success_message, vim.log.levels.INFO)
            else
                local output = (result.stderr ~= '' and result.stderr) or result.stdout
                vim.notify(('git %s failed:\n%s'):format(args[1], output), vim.log.levels.ERROR)
            end
        end)
    end)
end

vim.keymap.set('n', '<leader>gn', '<cmd>Neogit<CR>', { desc = 'Neo[g]it' })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<CR>', { desc = '[C]ommit' })
vim.keymap.set('n', '<leader>gs', function()
    run_git({ 'add', '-A' }, 'Staged all changes')
end, { desc = '[S]tage all changes' })
vim.keymap.set('n', '<leader>gp', function()
    run_git({ 'push' }, 'Pushed')
end, { desc = '[P]ush' })