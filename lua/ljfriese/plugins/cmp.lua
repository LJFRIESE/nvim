return { -- Autocompletion
  lazy = true,
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',
    'f3fora/cmp-spell',

    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',

    'ray-x/cmp-treesitter',
    'ray-x/cmp-sql',
    -- Symbols
    'onsails/lspkind-nvim',
    'kdheepak/cmp-latex-symbols',

    'jmbuhr/otter.nvim',
    'R-nvim/cmp-r',
    'jmbuhr/cmp-pandoc-references',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mode = "symbol_text",
      completion = { completeopt = 'menu,menuone,noinsert' },
      mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Jump to next field in completion template
        ['<C-n>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            fallback()
          end
        end, { 'i', 's' }),
        -- Jump to prev field in completion template
        ['<C-p>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<c-y>'] = cmp.mapping.confirm({
          select = true,
        }),

        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif has_words_before() then
            cmp.complete()
          else
          fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      autocomplete = false,

      ---@diagnostic disable-next-line: missing-fields
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
            spell = '[spell]',
            pandoc_references = '[ref]',
            tags = '[tag]',
            calc = '[calc]',
            latex_symbols = '[tex]',
          },
        }),
      },
      experimental = {
          ghost_text = false
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.score,
            cmp.config.compare.locality,
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
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
      sources = {
        { name = 'otter' }, -- for code chunks in quarto
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 3, max_item_count = 3 },
        { name = 'pandoc_references' },
        { name = 'buffer', keyword_length = 2, max_item_count = 3 },
        { name = 'spell' },
        { name = 'treesitter', keyword_length = 2, max_item_count = 3 },
        { name = 'calc' },
        { name = 'latex_symbols' },
        { name = 'emoji' },
        { name = 'vim-dadbod-completion' },
        { name = 'cmp_r' },
        { name = 'pyright' },
      },
      view = {
        entries = 'native',
      },
      window = {
           completion = cmp.config.window.bordered(),
           documentation = cmp.config.window.bordered()
      },
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
