return { -- nuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'UIEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'BurntSushi/ripgrep',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local builtin = require('telescope.builtin')
    local utils = require('telescope.utils')
    local themes = require('telescope.themes')

    -- Search (grep) functions
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[K]eymaps' })
    vim.keymap.set('n', '<leader>sT', builtin.builtin, { desc = '[T]elescopes' })
    vim.keymap.set('n', '<leader>sc', builtin.grep_string, { desc = 'Word under [c]ursor' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = '[R]egisters' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[R]esume' })
    -- vim.keymap.set('n', '<leader>spp', function() builtin.planets({show_pluto = true, show_moon = true}) end, { desc = '' })

    -- Grep in current buffer
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        prompt_title = 'Search Current Buffer',
        previewer = false,
      }))
    end, { desc = '[/] Current buffer' })

    -- Grep in all currently active buffers
    vim.keymap.set('n', '<leader>sb', function()
      builtin.live_grep(themes.get_dropdown({
        prompt_title = 'Search Active Buffers',
        grep_open_files = true,
      }))
    end, { desc = 'Active [b]uffers' })

    -- Grep in all files in same dir as current buf
    vim.keymap.set('n', '<leader>sd', function()
      builtin.live_grep(themes.get_dropdown({
        prompt_title = 'Search Local Directory  (Relative to active buffer)',
        cwd = utils.buffer_dir(),
      }))
    end, { desc = 'Local [d]irectory' })

    vim.keymap.set('n', '<leader>sw', function()
      builtin.live_grep(themes.get_dropdown({
        prompt_title = '[W]orkspace',
      }))
    end, { desc = 'Workspace' })

    -- Buffer/File-finding functions
    -- Base find
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers(themes.get_dropdown({
        prompt_title = 'Find Active Buffers',
        previewer = false,
        path_display = { 'tail' },
      }))
    end, { desc = '[ ] Find active buffers' })

    vim.keymap.set('n', '<leader>f.', function()
      builtin.oldfiles(themes.get_dropdown({
        prompt_title = 'Find Recent Files',
        previewer = false,
        path_display = { 'tail' },
      }))
    end, { desc = '[.] Recent files' })

    vim.keymap.set('n', '<leader>fl', function()
      builtin.find_files(themes.get_dropdown({
        prompt_title = 'Find Local Files (Relative to active buffer)',
        cwd = utils.buffer_dir(),
        previewer = false,
      }))
    end, { desc = '[L]ocal files' })
    -- Local dirs don't need tail
    vim.keymap.set('n', '<leader>fd', function()
      builtin.find_files(themes.get_dropdown({
        previewer = false,
      }))
    end, { desc = '[D]irectory files' })

    vim.keymap.set('n', '<leader>fw', function()
      builtin.git_files(themes.get_dropdown({
        previewer = true,
      }))
    end, { desc = '[W]orkspace files' })

    -- Find files in nvim dir
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files(themes.get_dropdown({
        previewer = false,
        prompt_title = 'Neovim Directory',
        cwd = vim.fn.stdpath('config'),
      }))
    end, { desc = '[N]eovim' })

    -- Find files in work git dir
    vim.keymap.set('n', '<leader>f_', function()
      builtin.find_files(themes.get_dropdown({ previewer = false, prompt_title = 'Git Projects Directory', cwd = '~/git' }))
    end, { desc = 'Git (Work)' })

    -- Lsp functions

    -- Fuzzy find all the symbols in your current document.
    vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = '[s]ymbols (Buffer)' })
    vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]ymbols (Workspace)' })
    -- vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = '[G]oto [D]efinition' })
    -- vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
    -- vim.keymap.set('n', 'gI', builtin.lsp_implementations, { desc = '[G]oto [I]mplementation' })
    -- vim.keymap.set('n', 'gT', builtin.lsp_type_definitions, { desc = '[G]oto [T]ype' })

    require('telescope').setup({
      defaults = {
        path_display = { 'truncate' }, --shorten = {len = 1, exclude = {-1,-2}}},
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })
    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
