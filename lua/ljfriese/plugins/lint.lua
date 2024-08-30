return
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      local sqlfluff = require('lint').linters.sqlfluff
      -- made local changes to SQLFLUFF config in nvim-lint.
      -- local severity = vim.diagnostic.severity.WARN
      --  if violation.code == "PRS" then
      --   severity = vim.diagnostic.severity.ERROR
      --  end
      --  table.insert(diagnostics, {
      --      source = 'sqlfluff',
      --      lnum = (violation.line_no or violation.start_line_no) - 1,
      --      col = (violation.line_pos or violation.start_line_pos) - 1,
      --      severity = severity,
      --      message = violation.description,
      --      user_data = {lsp = {code = violation.code}},
      --    })
      -- end
      sqlfluff.args = {
        'lint',
        -- '--logger=parser' ,
        '--format=json',
        '--dialect=oracle',
        '--processes=-1',
      }
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        -- quarto = { 'lintr' },
        sql = { 'sqlfluff' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
          -- print('Lint complete')
        end,
      })
      vim.keymap.set('n', 'gl', function()
        lint.try_lint()
      end, { desc = '[L]int' })
    end, -- Autoformat
  }
