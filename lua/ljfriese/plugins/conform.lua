local slow_format_filetypes = {}
return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = true,
  cmd = { "ConformInfo" },
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    notify_on_error = true,
    formatters = {
      sqlfluff = {
        args = { 'fix', '--dialect=oracle', '-' },
      },
      sql_formatter = {
        args = {
          '--config',
          '{ "lanaguage": "plsql", }'
        }
        --args = {
        --   '--language',
        --   'plsql',
          -- '--tabWidth',
          -- '\t',
          -- '--useTabs',
          -- 'true',
          -- '--keywordCase',
          -- 'upper',
          -- '--dataTypeCase',
          -- 'upper',
          -- '--functionCase',
          -- 'upper',
          -- '--identifierCase',
          -- 'upper',
          -- '--logicalOperatorNewline',
          -- 'after',
          -- '--expressionWidth',
          -- '88',
          -- '--linesBetweenQueries',
          -- '2',
          -- '--denseOperators',
          -- 'false',
          -- '--newlineBeforeSemicolon',
          -- 'true',
        -- },
      },
    },
    formatters_by_ft = {
      python = { 'ruff_format' },
      lua = { 'stylua' },
      sql = { 'sqlfluff' }, --'sql_formatter',
      r = { 'styler' },
      quarto = { 'styler' },
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
  }
