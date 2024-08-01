return {
  lazy = true,
  -- Linting
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')
    local sqlfluff = require('lint').linters.sqlfluff
    sqlfluff.args = {
      'lint',
      '--format=json',
      '--dialect=oracle',
      '--processes=-1',
    }

    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      quarto = { 'lintr' },
      sql = { 'sqlfluff' },
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })
    vim.keymap.set('n', '<leader>l', function()
      lint.try_lint()
    end, { desc = '[L]int buffer' })
  end,
}
