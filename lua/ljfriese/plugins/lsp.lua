return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  -- event = 'VeryLazy',
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = { ui = { title = 'Mason', border = 'rounded' } },
    },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0, border = 'rounded' } } } },
    'hrsh7th/cmp-nvim-lsp',
    { 'ray-x/lsp_signature.nvim', opts = { hint_enable = false, floating_window = true}},
  },
  opts = function()
    -- pop up border
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.title = 'X-SIG'
      opts.border = 'rounded'
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event) -- having maps in callback here means the keybinds only exist when lsp is active
        require('lsp_signature').on_attach({
          toggle_key = '<c-k>', -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
          toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
          -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
          --      -- may not popup when typing depends on floating_window setting
          hint_enable = true,
          hint_inline = function()
            return 'eol'
          end,
        })

        vim.opt_local.omnifunc = 'v:lua.vim.lsp.omnifunc'

        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
        end
        local builtin = require('telescope.builtin')
        -- Jump to the definition of the word under your cursor.
        --  To jump back, press <C-t>.
        -- Rename the variable under your cursor.
        map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('gT', builtin.lsp_type_definitions, '[G]oto [T]ype')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>x', vim.lsp.buf.code_action, 'Execute code action')
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
        -- The following autocommand is used to enable inlay hints
        -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        --   map('<leader><C-h>', function()
        --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        --   end, 'Toggle [H]ide hints')
        -- end
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
    -- stops quarto preview fighting with nvim
    -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

    capabilities.textDocument.foldingRange = { lineFoldingOnly = true }
    local servers = {
      markdown_oxide = {
        filetypes = { 'markdown' },
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
      sqls = {
        cmd = { 'sqls', '-config', 'config.yml' },
        filetypes = { 'sql' },
        root_dir = util.root_pattern('config.yml'),
        server_capabilities = {
          documentFormattingProvider = false,
        },
      },
      marksman = {
        filetypes = { 'quarto' },
        root_dir = util.root_pattern('.git', '.marksman.toml', '_quarto.yml'),
      },
      r_language_server = {
        server_capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = false,
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
          semanticTokensProvider = vim.NIL,
        },
        settings = {
          Lua = {
            -- completion = {
            --   callSnippet = 'Replace',
            -- },
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
