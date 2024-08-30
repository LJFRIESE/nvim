return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = {
        ui = { title = 'Mason', border = 'rounded' },

    log_level = vim.log.levels.DEBUG,
      },
    },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0, border = 'rounded' } } } },
    'hrsh7th/cmp-nvim-lsp',
  },
  opts = function()
    require('lspconfig.ui.windows').default_options.border = 'rounded'
    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      -- having maps in callback here means the keybinds only exist when lsp is active
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local builtin = require('telescope.builtin')
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
        end

        vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

        ---@diagnostic disable-next-line
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
          opts = opts or {}
          opts.title = (client and client.name .. '') or 'LSP'
          opts.border = 'rounded'
          return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('gT', builtin.lsp_type_definitions, '[G]oto [T]ype')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>x', vim.lsp.buf.code_action, 'Execute code action')
        -- Hover and signature information is decided by LSP creator. Sometimes one is more useful than the other.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>K', vim.lsp.buf.signature_help, 'Signature help')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        -- When you move your cursor, the highlights will be cleared (the second autocommand).

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

        -- Override server capabilities
        --https://github.com/tjdevries/config.nvim/blob/master/lua/custom/plugins/lsp.lua
        if client and client.settings.server_capabilities then
          for k, v in pairs(client.settings.server_capabilities) do
            if v == vim.NIL then
              ---@diagnostic disable-next-line: cast-local-type
              v = nil
            end
            client.server_capabilities[k] = v
          end
        end
      end,
    })
  end,
  config = function(_, opts)
    local lsp_flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    }

    local util = require('lspconfig.util')
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    capabilities.textDocument.foldingRange = { lineFoldingOnly = true }
    local servers = {
      markdown_oxide = {
        filetypes = { 'markdown', 'quarto' },
        server_capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
      },
      ruff = {
        filetypes = { 'python' },
      },
      -- SQLS is a little bitch. It will only run with this exact cmd.
      -- config.yml file must be in the /user/{USER}
      -- Anything else and it will break.
      -- SQLS is CASE-SENSITIVE from join snippets. Table names must be matched to
      -- trigger them.
      sqls = {
        cmd = { 'sqls', '-config', 'config.yml' },
        server_capabilities = {
          documentFormattingProvider = false,
        },
      },
      -- marksman = {
      --   filetypes = { 'quarto' },
      --   root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
      -- },
      r_language_server = {
        server_capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = false, -- stops quarto preview fighting with nvim
            },
          },
        },
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
        server_capabilities = {
          -- semanticTokensProvider = vim.NIL,
        },
        settings = {
          Lua = {
            diagnostics = { disable = { 'missing-parameter', 'missing-fields' }, globals = { 'vim' } },
          },
        },
      },
    }


    require('mason').setup(opts)
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'lua_ls',
      'ruff',
      'jq',
      'sqls',
      'prettierd',
      'markdown_oxide',
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
