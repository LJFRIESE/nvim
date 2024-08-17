<<<<<<< HEAD
local slow_format_filetypes = {}
-- local log = require("conform.log")
=======
>>>>>>> af86fb1 (pl no conform)
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
      vim.keymap.set('n', '<leader>bl', function()
        lint.try_lint()
      end, { desc = '[L]int' })
    end, -- Autoformat
  },
  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = { {
      '<leader>bf',
      function()
        require('conform').format({ async = false })
        print('Format complete')
      end,
      mode = '',
      desc = '[F]ormat',
    }
    },
    opts = {
<<<<<<< HEAD
      -- log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      formatters = {
        sqlfluff = {
          args = { 'fix', '--dialect=oracle', '--processes=-1' },
        },
      },
=======
      log_level = vim.log.levels.DEBUG,
>>>>>>> af86fb1 (pl no conform)
      -- Mason installs LSP, formatters, and linters.
      -- When possible, ensure installs over here: ./lsp.lua
      formatters_by_ft = {
        markdown = { 'prettierd' },
        python = { 'ruff_format' },
        lua = { 'stylua' },
        sql = { 'sqlfluff' },
        r = { 'styler' },
        quarto = { 'styler' },
        -- Use the "*" filetype to run formatters on all filetypes.

        -- Set default options
        default_format_opts = {
          lsp_format = 'fallback',
        },
        -- Set up format-on-save
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end,

<<<<<<< HEAD
        return { timeout_ms = 500, lsp_format = 'fallback' }, on_format
      end,

      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_format = 'fallback' }
      end,
=======
        -- log_level = vim.log.levels.DEBUG,
        notify_on_error = true,
        formatters = {
          sqlfluff = {
            args = { 'fix', '--dialect=oracle', '--processes=-1', '-' },
          },
        },
      },
>>>>>>> af86fb1 (pl no conform)
    },
    config = function()
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
      vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
          }
        end
        require('conform').format({ async = true, lsp_format = 'fallback', range = range })
      end, { range = true })
    end,
  },
}
