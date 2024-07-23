return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    formatters = {
      sqlfluff = {
        inherit = true,
        command = 'sqlfluff',
        args = { 'lint', '--dialect', 'oracle', '--processes', -1 },
        stdin = true,
        require_cwd = false,
      },
    },

    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {}
      local slow_timeout = { r = true, qmd = true, sql = true }
      local timeout = 500
      if slow_timeout[vim.bo[bufnr].filetype] then
        timeout = 50000
      end
      return {
        timeout_ms = timeout,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      sql = { 'sqlfmt' },
      r = { 'styler' },
      quarto = { 'styler' },
    },
  },
}
