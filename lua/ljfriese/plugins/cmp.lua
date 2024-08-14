return { -- Autocompletio
  lazy = true,
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'folke/lazydev.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-calc',

    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    -- 'onsails/lspkind.nvim',
    'kristijanhusak/vim-dadbod-completion',
    'ray-x/cmp-treesitter',
    -- Symbols
    'kdheepak/cmp-latex-symbols',
    {"lspkind", dir = "$LOCALAPPDATA/nvim/projects/lspkind", dev = true},
    'jmbuhr/otter.nvim',
    'R-nvim/cmp-r',
    -- 'jmbuhr/cmp-pandoc-references',
  },
  config = function()
    local cmp = require('cmp')
    local types = require("cmp.types")

    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    ---@type table<integer, integer>
    local modified_priority = {
      [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
      [types.lsp.CompletionItemKind.Snippet] = 0, -- top
      [types.lsp.CompletionItemKind.Keyword] = 0, -- top
      [types.lsp.CompletionItemKind.Text] = 100, -- bottom
    }
    ---@param kind integer: kind of completion entry
    local function modified_kind(kind)
      return modified_priority[kind] or kind
    end

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mode = 'symbol',
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
          winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,Search:None',
          -- col_offset = -3,
          -- side_padding = 0,
        },
        documentation = {
          title = 'Documentation',
          border = 'rounded',
          winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,Search:None',
          max_height = math.floor(vim.o.lines * 0.5),
          max_width = math.floor(vim.o.columns * 0.4),
        },
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
          },
        }),
      },
      experimental = {
        ghost_text = false,
      },
      matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = true,
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.recently_used,
          function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
            local kind1 = modified_kind(entry1:get_kind())
            local kind2 = modified_kind(entry2:get_kind())
            if kind1 ~= kind2 then
              return kind1 - kind2 < 0
            end
          end,
          function(entry1, entry2) -- score by lsp, if available
            local t1 = entry1.completion_item.sortText
            local t2 = entry2.completion_item.sortText
            if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
              return t1 < t2
            end
          end,
          cmp.config.compare.locality,
          cmp.config.compare.length,
          cmp.config.compare.score,
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
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lsp' },
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
    })

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
        { name = 'nvim_lsp', max_item_count = 4 },
        { name = 'vim-dadbod-completion', max_item_count = 3 },
        { name = 'luasnip', max_item_count = 2 },
        { name = 'sqls' },
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

    -- interesting idea to explore for formatting documentation
    -- https://github.com/MariaSolOs/dotfiles/blob/e61e14e92aef1f8229d4b86498f40f1c97e45f9c/.config/nvim/lua/plugins/nvim-cmp.lua
    --         require("module")
    --           ---@diagnostic disable-next-line: duplicate-set-field
    --           require('cmp.entry').get_documentation = function(self)
    --                 local item = self:get_completion_item()
    --
    --                 if item.documentation then
    --                     return vim.lsp.util.convert_input_to_markdown_lines(item.documentation)
    --                 end
    --
    --                 -- Use the item's detail as a fallback if there's no documentation.
    --                 if item.detail then
    --                     local ft = self.context.filetype
    --                     local dot_index = string.find(ft, '%.')
    --                     if dot_index ~= nil then
    --                         ft = string.sub(ft, 0, dot_index - 1)
    --                     end
    --                     return (vim.split(('```%s\n%s```'):format(ft, vim.trim(item.detail)), '\n'))
    --                 end
    --
    --                 return {}
    --             end
    -- for friendly snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    -- for custom snippets
    -- uncomment if you decide to use them.
    -- require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snips' } })
    -- link quarto and rmarkdown to markdown snippets
    luasnip.filetype_extend('quarto', { 'markdown' })
    luasnip.filetype_extend('rmarkdown', { 'markdown' })
  end,
}
