return {
  'folke/trouble.nvim',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '[t',
      function()
        if require('trouble').is_open() then
          require('trouble').next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Jump to next error',
    },
    {
      ']t',
      function()
        if require('trouble').is_open() then
          require('trouble').prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = 'Jump to prev error',
    },
    {
      'tt',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = '[T]rouble Diagnostics',
    },
    {
      'tb',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = '[B]uffer Diagnostics',
    },
    {
      'ts',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = '[S]ymbols (Trouble)',
    },
    {
      'td',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = '[D]efinitions / references',
    },
    {
      'tl',
      '<cmd>Trouble loclist toggle<cr>',
      desc = '[L]ocation List',
    },
    {
      'tq',
      '<cmd>Trouble qflist toggle<cr>',
      desc = '[Q]uickfix List',
    },
  },
}
