return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  keys = {
    {
      'gw',
      function()
        require('conform').format({ async = true })
      end,
      mode = '',
      desc = 'Format',
    },
  },
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    notify_on_error = true,
    formatters = {
      sqlfluff = {
        args = {
          'fix',
          '--dialect=oracle',
          '--processes=-1',
        },
      },
      styler = {
        -- hijacking "https://github.com/devOpifex/r.nvim",
        args = { '-s', '-e', 'styler::style_file(commandArgs(TRUE))', '--args', '$FILENAME' },
        stdin = false,
      },
    },

    -- Mason installs LSP, formatters, and linters.
    -- When possible, ensure installs over here: ./lsp.lua
    formatters_by_ft = {
      markdown = { 'prettierd' },
      python = { 'ruff_format' },
      lua = { 'stylua' },
      sql = { 'sqlfluff' },
      r = { 'styler' },
      quarto = { 'styler' },
      json = { 'jq' },
      -- Use the "*" filetype to run formatters on all filetypes.

      default_format_opts = {
        lsp_format = 'fallback',
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
    },
  },
  init = function()
    require('conform').setup({
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
      }),
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      }),
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
      end, { range = true }),
    })
  end,
}
