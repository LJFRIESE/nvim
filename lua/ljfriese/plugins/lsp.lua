return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = {
      -- log_level = vim.log.levels.DEBUG,
      ui = { title = 'Mason', border = 'rounded' } } }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = { notification = { window = { border = 'rounded' } } } },
      'hrsh7th/cmp-nvim-lsp',
      { 'ray-x/lsp_signature.nvim' },
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      -- require('lspconfig.ui.windows').default_options.title = LspInfoList

      -- pop up border
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.title = 'LSP'
        opts.border = 'rounded'
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event) -- having maps in callback here means the keybinds only exist when lsp is active
          require('lsp_signature').on_attach({
            hint_enable = false,
            hint_inline = function()
              return 'eol'
            end,
          })

          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gT', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype')
          -- Fuzzy find all the symbols in your current document.
          map('<leader>syd', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>syw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          -- Rename the variable under your cursor.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>gx', vim.lsp.buf.code_action, 'Execute code action')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader><C-h>', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, 'Toggle [H]ide hints')
          end
        end,
      })
      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }
      local util = require('lspconfig.util')
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      -- stops quarto preview fighting with nvim
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      capabilities.textDocument.foldingRange = { lineFoldingOnly = true }
      local servers = {
        prettierd = { 'markdown' },
        html = { 'html' },
        ruff = { 'python' },
        sqls = {
          cmd = { 'sqls', "-config", "config.yml"},
          filetypes = { 'sql' },
          root_dir = util.root_pattern('config.yml'),
                 },
        marksman = { filetypes = { 'quarto' }, root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml') },
        r_language_server = {
          settings = {
            r = {
              flags = lsp_flags,
              lsp = {
                rich_documentation = false,
              },
            },
          },
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-parameter', 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'html',
        'lua_ls',
        'ruff',
        'sqls',
        -- 'pyright',
        'stylua',
        'sqlfluff',
        'tree-sitter-cli',
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  }
