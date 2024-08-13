return { -- Autocompletio
  lazy = true,
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',

    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',

    "kristijanhusak/vim-dadbod-completion",
    'ray-x/cmp-treesitter',
    -- 'ray-x/cmp-sql',
    -- Symbols
    'onsails/lspkind-nvim',
    'kdheepak/cmp-latex-symbols',

    'jmbuhr/otter.nvim',
    'R-nvim/cmp-r',
    -- 'jmbuhr/cmp-pandoc-references',
  },

  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mode = 'symbol_text',
      completion = { completeopt = 'menu,menuone,noinsert' },
      autocomplete = false,
      mapping = {
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
      ---@diagnostic disable-next-line: missing-fields
      view = {
        entries = 'custom',
      },
      window = {
        completion = {
          border = 'rounded',
          winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,Search:None',
          col_offset = -3,
          side_padding = 0,
        },
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format({
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
            sql = '[sql]',
          },
        }),
      },
      experimental = {
        ghost_text = false,
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          cmp.config.compare.score,
          cmp.config.compare.locality,
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find('^_+')
            local _, entry2_under = entry2.completion_item.label:find('^_+')
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,

          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      sources = cmp.config.sources({
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        {
          { name = 'luasnip', max_item_count = 3 },
          { name = 'buffer', max_item_count = 3 },
        },
        {
          { name = 'nvim_lsp_signature_help' },
          -- { name = "vim-dadbod-completion",},
          { name = 'nvim_lsp' },
          { name = 'treesitter', max_item_count = 3 },
        },
        {
          { name = 'otter' }, -- for code chunks in quarto
          { name = 'path' },
          -- { name = 'pandoc_references' },
          { name = 'calc' },
          { name = 'latex_symbols' },
          { name = 'cmp_r' },
        },
      }),
    })

    -- Setup up vim-dadbod
    cmp.setup.filetype({ 'sql' }, {
      sources = {
        { name = 'vim-dadbod-completion' },
        -- { name = 'sql' }
         { name = 'nvim_lsp' },
          { name = 'treesitter', max_item_count = 3 },
        { name = 'buffer' },
      },
    })
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
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
    -- for friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    -- for custom snippets
    require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snips' } })
    -- link quarto and rmarkdown to markdown snippets
    luasnip.filetype_extend('quarto', { 'markdown' })
    luasnip.filetype_extend('rmarkdown', { 'markdown' })
  end,
}
