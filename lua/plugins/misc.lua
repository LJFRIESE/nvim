vim.pack.add({
    { src = 'https://github.com/brenoprata10/nvim-highlight-colors', },
})

-- Use Neovim 0.12 built-in undo tree
vim.keymap.set('n', "<leader>u", "<cmd>Undotree<CR>", { desc = '[u]ndo tree' })

require("nvim-highlight-colors").setup()
