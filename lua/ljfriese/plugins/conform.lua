return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local slow_timeout = { r = true, qmd = true }
      local timeout = 500
      if slow_timeout[vim.bo[bufnr].filetype] then
        timeout = 2000
      end
      return {
        timeout_ms = timeout,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      sql = { 'sqlfmt', 'sqlfluff' },
      r = { 'styler' },
      qmd = { 'styler' },
    },
  },
}
