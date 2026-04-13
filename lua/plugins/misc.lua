vim.pack.add({
    { src = 'https://github.com/jiaoshijie/undotree', },
    { src = 'https://github.com/brenoprata10/nvim-highlight-colors', },
})

require("undotree").setup()

vim.keymap.set('n', "<leader>u", function() require('undotree').toggle() end, { desc = '[u]ndo tree' })

require("nvim-highlight-colors").setup()
