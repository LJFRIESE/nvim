return {
  lazy = true,
  'folke/zen-mode.nvim',
  config = function()
      require('zen-mode').setup({
        window = {
          width = 90,
          options = {},
        },
      })
  end,
}
