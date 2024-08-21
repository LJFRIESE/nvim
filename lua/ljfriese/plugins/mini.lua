return {

  {
    'echasnovski/mini.starter',
    version = '*',
    dependencies = {
      'echasnovski/mini.sessions',
    'nvim-telescope/telescope-file-browser.nvim'
    },
    config = function()
      require('mini.sessions').setup()
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
      ---@diagnostic disable-next-line: duplicate-set-field
      section_location = function()
        return '%2l:%-2v'
      end,
    },
  },
}
