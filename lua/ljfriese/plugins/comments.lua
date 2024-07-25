return {
  'numToStr/Comment.nvim',
  opts = function()
    vim.keymap.set('n', '<leader>cc', function()
      return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
    end, { expr = true, desc = 'Toggle comment' })
    vim.keymap.set('n', 'cc', '<Plug>(comment_toggle_linewise)', { desc = 'Toggle comment {motion}' })
    vim.keymap.set('x', '<leader>cc', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment' })

    vim.keymap.set('n', '<leader>cb', function()
      return vim.v.count == 0 and '<Plug>(comment_toggle_blockwise_current)' or '<Plug>(comment_toggle_blockwise_count)'
    end, { expr = true, desc = 'Toggle comment block' })
    vim.keymap.set('n', 'cb', '<Plug>(comment_toggle_blockwise)', { desc = 'Toggle block comment {motion}' })
    vim.keymap.set('x', '<leader>cb', '<Plug>(comment_toggle_blockwise_visual)', { desc = 'Toggle block comment' })
  end,
}
