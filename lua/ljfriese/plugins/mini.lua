return {
  {
    'echasnovski/mini.sessions',
    event = 'VimEnter',
    version = '*',
    init = function()
      require('mini.sessions').setup({})
    end,
  },
  {
    'echasnovski/mini.starter',
    lazy = false,
    version = '*',
    dependencies = {
      { 'echasnovski/mini.sessions' },
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      -- require('mini.sessions').setup()
      local starter = require('mini.starter')
      starter.setup({
        items = {
          starter.sections.sessions,
          starter.sections.telescope(),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
        },
      })
    end,
  },
  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    opts = {
      -- Add custom surroundings to be used on top of builtin ones. For more
      -- information with examples, see `:h MiniSurround.config`.
      custom_surroundings = nil,

      -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
      highlight_duration = 500,

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',

        update_n_lines = '',
        suffix_last = '',
        suffix_next = '',
      },

      -- Number of lines within which surrounding is searched
      n_lines = 50,
      respect_selection_type = false,
      search_method = 'cover',
      silent = false,
    },
    config = function(_, opts)
      require('mini.surround').setup(opts)
    end,
  },
  {
    -- Simple and easy statusline.
    'echasnovski/mini.statusline',
    opts = {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local MiniStatusline = require('mini.statusline')
          -- local MiniSessions = require('mini.sessions')
          local get_session = function()
            if vim.v.this_session ~= '' then
              return vim.fs.basename(vim.v.this_session)
            else
              return 'No Active Session'
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          -- local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<%=', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { '%t' .. ' | ' .. get_session() } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, '%2l:%-2L' } },
          })
        end,
      },
    },
  },
}
