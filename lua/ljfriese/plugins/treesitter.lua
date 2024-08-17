return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
  build = ':TSUpdate',
  opts = {
    ensure_installed = { 'yaml', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'vim', 'vimdoc', 'sql', 'r', 'markdown', 'markdown_inline', 'rnoweb', 'sql' },
    -- auto_install = true,
    -- highlight = {
    --   additionalvim_regex_highlighting={enable=true}},
    -- indent = {enable = true},
  },
  config = function(_, opts)
    require('nvim-treesitter.install').prefer_git = true
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup(opts)
    require('treesitter-context').setup({
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      separator = '-',
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    })
  end,
}
