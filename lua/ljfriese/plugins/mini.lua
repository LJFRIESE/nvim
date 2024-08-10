return {
  {
    'echasnovski/mini.ai',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function()
          -- no need to load the plugin, since we only need its queries
          require('lazy.core.loader').disable_rtp_plugin('nvim-treesitter-textobjects')
        end,
      },
    },
    opts = function()
      local ai = require('mini.ai')
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      return {
        n_lines = 500,
      custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          -- i = LazyVim.mini.ai_indent, -- indent
          -- g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      require('which-key').add({
        { mode = { 'o', 'x' },
          {'a', group = '[a]round',
            {
              { 'ao', desc = 'Block, conditional, loop' },
              { 'aq', desc = 'Quote `, ", \'' },
              { 'at', desc = 'Tag' },
              { 'a{', desc = 'Balanced {' },
              { 'a}', desc = 'Balanced }' },
              { 'a ', desc = 'Whitespace' },
              { 'a"', desc = 'Balanced "' },
              { "a'", desc = "Balanced '" },
              { 'a(', desc = 'Balanced (' },
              { 'a)', desc = 'Balanced )' },
              { 'a<', desc = 'Balanced <' },
              { 'a>', desc = 'Balanced >' },
              { 'a?', desc = 'User Prompt' },
              { 'a[', desc = 'Balanced [' },
              { 'a]', desc = 'Balanced ]' },
              { 'a_', desc = 'Underscore' },
              { 'a`', desc = 'Balanced `' },
              { 'aa', desc = 'Argument' },
              { 'ab', desc = 'Balanced ), ], }' },
              { 'ac', desc = 'Class' },
              { 'af', desc = 'Function' },
            },
            { { 'al', group = '[L]ast ...' },
              { 'al ', desc = 'Whitespace' },
              { 'al"', desc = 'Balanced "' },
              { "al'", desc = "Balanced '" },
              { 'al(', desc = 'Balanced (' },
              { 'al)', desc = 'Balanced )' },
              { 'al<', desc = 'Balanced <' },
              { 'al>', desc = 'Balanced >' },
              { 'al?', desc = 'User Prompt' },
              { 'al[', desc = 'Balanced [' },
              { 'al]', desc = 'Balanced ]' },
              { 'al_', desc = 'Underscore' },
              { 'al`', desc = 'Balanced `' },
              { 'ala', desc = 'Argument' },
              { 'alb', desc = 'Balanced ), ], }' },
              { 'alc', desc = 'Class' },
              { 'alf', desc = 'Function' },
              { 'alo', desc = 'Block, conditional, loop' },
              { 'alq', desc = 'Quote `, ", \'' },
              { 'alt', desc = 'Tag' },
              { 'al{', desc = 'Balanced {' },
              { 'al}', desc = 'Balanced }' },
            },
            { { 'an', group = '[N]ext ...' },
              { 'an ', desc = 'Whitespace' },
              { 'an"', desc = 'Balanced "' },
              { "an'", desc = "Balanced '" },
              { 'an(', desc = 'Balanced (' },
              { 'an)', desc = 'Balanced )' },
              { 'an<', desc = 'Balanced <' },
              { 'an>', desc = 'Balanced >' },
              { 'an?', desc = 'User Prompt' },
              { 'an[', desc = 'Balanced [' },
              { 'an]', desc = 'Balanced ]' },
              { 'an_', desc = 'Underscore' },
              { 'an`', desc = 'Balanced `' },
              { 'ana', desc = 'Argument' },
              { 'anb', desc = 'Balanced ), ], }' },
              { 'anc', desc = 'Class' },
              { 'anf', desc = 'Function' },
              { 'ano', desc = 'Block, conditional, loop' },
              { 'anq', desc = 'Quote `, ", \'' },
              { 'ant', desc = 'Tag' },
              { 'an{', desc = 'Balanced {' },
              { 'an}', desc = 'Balanced }' },
            },
          {'i', group = '[i]nside',
            {
              { 'i ', desc = 'Whitespace' },
              { 'i"', desc = 'Balanced "' },
              { "i'", desc = "Balanced '" },
              { 'i(', desc = 'Balanced (' },
              { 'i)', desc = 'Balanced ) including white-space' },
              { 'i<', desc = 'Balanced <' },
              { 'i>', desc = 'Balanced > including white-space' },
              { 'i?', desc = 'User Prompt' },
              { 'i[', desc = 'Balanced [' },
              { 'i]', desc = 'Balanced ] including white-space' },
              { 'i_', desc = 'Underscore' },
              { 'i`', desc = 'Balanced `' },
              { 'ia', desc = 'Argument' },
              { 'ib', desc = 'Balanced ), ], }' },
              { 'ic', desc = 'Class' },
              { 'if', desc = 'Function' },
              { 'in}', desc = 'Balanced } including white-space' },
              { 'io', desc = 'Block, conditional, loop' },
              { 'iq', desc = 'Quote `, ", \'' },
              { 'it', desc = 'Tag' },
              { 'i{', desc = 'Balanced {' },
              { 'i}', desc = 'Balanced } including white-space' },
            },
            { { 'il', group = '[L]ast ...' },
              { 'il ', desc = 'Whitespace' },
              { 'il"', desc = 'Balanced "' },
              { "il'", desc = "Balanced '" },
              { 'il(', desc = 'Balanced (' },
              { 'il)', desc = 'Balanced ) including white-space' },
              { 'il<', desc = 'Balanced <' },
              { 'il>', desc = 'Balanced > including white-space' },
              { 'il?', desc = 'User Prompt' },
              { 'il[', desc = 'Balanced [' },
              { 'il]', desc = 'Balanced ] including white-space' },
              { 'il_', desc = 'Underscore' },
              { 'il`', desc = 'Balanced `' },
              { 'ila', desc = 'Argument' },
              { 'ilb', desc = 'Balanced ), ], }' },
              { 'ilc', desc = 'Class' },
              { 'ilf', desc = 'Function' },
              { 'ilo', desc = 'Block, conditional, loop' },
              { 'ilq', desc = 'Quote `, ", \'' },
              { 'ilt', desc = 'Tag' },
              { 'il{', desc = 'Balanced {' },
              { 'il}', desc = 'Balanced } including white-space' },
            },
            { { 'in', group = '[N]ext ...' },
              { 'in ', desc = 'Whitespace' },
              { 'in"', desc = 'Balanced "' },
              { "in'", desc = "Balanced '" },
              { 'in(', desc = 'Balanced (' },
              { 'in)', desc = 'Balanced ) including white-space' },
              { 'in<', desc = 'Balanced <' },
              { 'in>', desc = 'Balanced > including white-space' },
              { 'in?', desc = 'User Prompt' },
              { 'in[', desc = 'Balanced [' },
              { 'in]', desc = 'Balanced ] including white-space' },
              { 'in_', desc = 'Underscore' },
              { 'in`', desc = 'Balanced `' },
              { 'ina', desc = 'Argument' },
              { 'inb', desc = 'Balanced ), ], }' },
              { 'inc', desc = 'Class' },
              { 'inf', desc = 'Function' },
              { 'ino', desc = 'Block, conditional, loop' },
              { 'inq', desc = 'Quote `, ", \'' },
              { 'int', desc = 'Tag' },
              { 'in{', desc = 'Balanced {' },
              { 'in}', desc = 'Balanced }' },
            },
          },
        },
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
        -- update_n_lines = 'gsn',

        suffix_last = '', -- Suffix to search with "prev" method
    suffix_next = '', -- Suffix to search with "next" method
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
