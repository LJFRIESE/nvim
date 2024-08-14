return { -- Autocompletio
  lazy = true,
  'hrsh7th/nvim-cmp',

  dependencies = {
    'folke/lazydev.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',
    {
      'L3MON4D3/LuaSnip',
      opts = function()
        local types = require('luasnip.util.types')

        return {
          -- Check if the current snippet was deleted.
          delete_check_events = 'TextChanged',
          -- Display a cursor-like placeholder in unvisited nodes
          -- of the snippet.
          ext_opts = {
            [types.insertNode] = {
              unvisited = {
                virt_text = { { '|', 'Conceal' } },
                virt_text_pos = 'inline',
              },
            },
            -- In sqls snippets this is leaving a | after the final ;
            -- [types.exitNode] = {
            --   unvisited = {
            --     virt_text = { { '|', 'Conceal' } },
            --     virt_text_pos = 'inline',
            --   },
            -- },
          },
        }
      end,
    },
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    -- 'onsails/lspkind.nvim',
    -- 'kristijanhusak/vim-dadbod-completion',
    'ray-x/cmp-treesitter',
    -- Symbols
    'kdheepak/cmp-latex-symbols',
    { 'lspkind', dir = '$LOCALAPPDATA/nvim/projects/lspkind', dev = true },
    'jmbuhr/otter.nvim',
    'R-nvim/cmp-r',
  },
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind') -- Local lspkind

    local winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None'

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    -- for friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    -- for custom snippets
    -- uncomment if you decide to use them.
    -- require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snips' } })
    -- link quarto and rmarkdown to markdown snippets
    luasnip.filetype_extend('quarto', { 'markdown' })
    luasnip.filetype_extend('rmarkdown', { 'markdown' })

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      autocomplete = false,
      mapping = {
        ['<C-g>'] = function()
          if cmp.visible_docs() then
            cmp.close_docs()
          else
            cmp.open_docs()
          end
        end,
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Jump to next field in completion template
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<c-y>'] = cmp.mapping.confirm({
          select = true,
        }),
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if luasnip.expandable() then
              luasnip.expand()
            else
              cmp.confirm({
                select = true,
              })
            end
          else
            fallback()
          end
        end),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      view = {
        entries = 'custom',
      },
      window = {
        completion = {
          title = 'Suggestions',
          border = 'rounded',
          winhighlight = winhighlight,
        },
        documentation = {
          title = 'Documentation',
          border = 'rounded',
          winhighlight = winhighlight,
          max_height = math.floor(vim.o.lines * 0.5),
          max_width = math.floor(vim.o.columns * 0.4),
        },
      },
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = '...',
          mode = 'symbol',
          menu = {
            otter = '[🦦]',
            nvim_lsp = '[LSP]',
            nvim_lsp_signature_help = '[sig]',
            luasnip = '[snip]',
            treesitter = '[TS]',
            buffer = '[buf]',
            path = '[path]',
            -- pandoc_references = '[ref]',
            tags = '[tag]',
            calc = '[calc]',
            latex_symbols = '[tex]',
            ['vim-dadbod-completion'] = '[DB]',
          },
        }),
      },
      experimental = {
        ghost_text = false,
      },
      matching = {
        -- see https://github.com/hrsh7th/nvim-cmp/blob/a110e12d0b58eefcf5b771f533fc2cf3050680ac/lua/cmp/matcher_spec.lua#L39
        -- matcher spec tests provide useful examples.
        -- Below command can inspect match scoring.
        -- :=require('cmp.matcher').match('RCC', 'CJB_RCCS_VW', {disallow_fuzzy_matching = true, disallow_fullfuzzy_matching = true, disallow_partial_fuzzy_matching = true, disallow_partial_matching = false, disallow_prefix_unmatching = false})
        disallow_fuzzy_matching = false,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
        disallow_symbol_nonprefix_matching = true,
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.scopes,
          cmp.config.compare.score,
          cmp.config.compare.kind,
          cmp.config.compare.recently_used,
          cmp.config.compare.length,
          cmp.config.compare.locality,
          function(entry1, entry2) -- score by lsp, if available
            -- print(entry1:get_completion_item().detail))
            local t1 = entry1.completion_item.sortText
            local t2 = entry2.completion_item.sortText
            if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
              return t1 < t2
            end
          end,
          cmp.config.compare.order,
        },
      },
      -- General setup
      sources = cmp.config.sources({
        name = 'lazydev',
        -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
        group_index = 0,
      }, {
        { name = 'luasnip', max_item_count = 3 },
        { name = 'buffer', max_item_count = 3 },
        group_index = 1,
      }, {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'treesitter', max_item_count = 3 },
        group_index = 2,
      }, {
        { name = 'otter' }, -- for code chunks in quarto
        { name = 'path' },
        -- { name = 'pandoc_references' },
        { name = 'calc' },
        { name = 'latex_symbols' },
        { name = 'cmp_r' },
        group_index = 3,
      }),
    }
  end,
  config = function(_, opts)
    local cmp = require('cmp')

    ---@diagnostic disable-next-line: duplicate-set-field
    require('cmp.entry').get_documentation = function(self)
      local item = self:get_completion_item()

      if item.documentation then
        return vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
      end

      -- Use the item's detail as a fallback if there's no documentation.
      if item.detail then
        local ft = self.context.filetype
        local dot_index = string.find(ft, '%.')
        if dot_index ~= nil then
          ft = string.sub(ft, 0, dot_index - 1)
        end
        return (vim.split(('```%s\n%s```'):format(ft, vim.trim(item.detail)), '\n'))
      end

      return {}
    end
    cmp.setup(opts)
    cmp.setup.filetype({ 'markdown' }, {
      sources = {
        { name = 'buffer', max_item_count = 3 },
        { name = 'path' },
        { name = 'calc' },
        { name = 'latex_symbols' },
        { name = 'treesitter', max_item_count = 3 },
      },
    })

    -- Setup sql
    cmp.setup.filetype({ 'sql' }, {
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vim-dadbod-completion' },
        { name = 'luasnip', max_item_count = 3 },
        { name = 'treesitter' },
        { name = 'buffer' },
      },
    })
    -- `/` cmdline setup.
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
          },
        },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
    })
    -- Inside a snippet, use backspace to remove the placeholder.
    vim.keymap.set('s', '<BS>', '<C-O>s')
  end,
}
