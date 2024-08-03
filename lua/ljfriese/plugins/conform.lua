local slow_format_filetypes = {}
return {
  -- Linting
  {
    'mfussenegger/nvim-lint',
    lazy = true,
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
          -- print('Lint complete')
        end,
      })
      vim.keymap.set('n', '<leader>bl', function()
        lint.try_lint()
      end, { desc = '[L]int' })
    end, -- Autoformat
  },
  -- Formatting
  {
    'stevearc/conform.nvim',
    lazy = true,
    cmd = { 'ConformInfo' },
    opts = {
      -- log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      formatters = {
        sqlfluff = {
          args = { 'fix', '--dialect=oracle', '--process=-1', '-' },
        },
      },
      -- Mason installs LSP, formatters, and linters.
      -- When possible, ensure installs over here: ./lsp.lua
      formatters_by_ft = {
        python = { 'ruff_format' },
        lua = { 'stylua' },
        sql = { 'sqlfluff' },
        r = { 'styler' },
        quarto = { 'styler' },
        -- Use the "*" filetype to run formatters on all filetypes.
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local function on_format(err)
          if err and err:match('timeout$') then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 200, lsp_format = 'fallback' }, on_format
      end,

      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_format = 'fallback' }
      end,
    },
  },
}
