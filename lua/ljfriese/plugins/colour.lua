return {
  'tanvirtin/monokai.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.}
  opts = {
    italics = false,
  },
  init = function()
    vim.cmd.colorscheme('monokai_pro')
  vim.api.nvim_set_hl(0, 'TreesitterContext', { link = 'Normal', default = true })
    -- vim.cmd.hi('Comment gui=none')
  end,
}
