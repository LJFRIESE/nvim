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

require('neogit').setup({
    git_executable = git_executable,
    integrations = { diffview = true },
})

vim.keymap.set('n', '<leader>gn', '<cmd>Neogit<CR>', { desc = 'Neo[g]it' })