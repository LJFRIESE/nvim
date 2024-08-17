return {
  'folke/zen-mode.nvim',
  event = "BufReadPost",
  config = function()
      require('zen-mode').setup({
        window = {
          width = 90,
          options = {},
        },
      })
  end,
}
