return{
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  event = 'VeryLazy',
  config = function()
vim.diagnostic.config({ virtual_lines = false })
    vim.diagnostic.config({virtual_text=true})
    require('lsp_lines').setup()
    vim.keymap.set('', '<leader>bl',
    function()
      require('lsp_lines').toggle()
      vim.diagnostic.config( {virtual_text = not vim.diagnostic.config().virtual_text })
    end,
    { desc = 'Toggle diagnostic [l]ines' }
    )
  end
}
