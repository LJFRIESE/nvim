return {
  'folke/zen-mode.nvim',
  config = function()
    vim.keymap.set('n', '<c-z>z', function()
      require('zen-mode').setup({
        window = {
          width = 90,
          options = {},
        },
      })
      require('zen-mode').toggle()
      vim.wo.wrap = false
      vim.wo.number = true
      vim.wo.rnu = true
    end, { desc = '[Z]en mode' })
  end,
}

