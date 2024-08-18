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
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[K]eymaps' })
    vim.keymap.set('n', '<leader>sB', builtin.builtin, { desc = '[B]uiltin Telescopes' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[W]ord under cursor' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = '[R]egisters' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[R]esume' })
    -- vim.keymap.set('n', '<leader>spp', function() builtin.planets({show_pluto = true, show_moon = true}) end, { desc = '' })

    -- Buffer/File-finding functions
    vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = '[F]iles in current project' })
    vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = 'Current [D]irectory files' })
    vim.keymap.set('n', '<leader>f.', function()
      builtin.oldfiles(themes.get_dropdown({
        prompt_title = 'Find Recent Files',
        cwd = utils.buffer_dir(),
        previewer = false,
      }))
    end, { desc = '[.] Recent files' })

    vim.keymap.set('n', '<leader>fl', function()
      builtin.find_files(themes.get_dropdown({
        prompt_title = 'Find Local Files',
        cwd = utils.buffer_dir(),
        previewer = false,
      }))
    end, { desc = '[L]ocal Files' })

    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers(themes.get_dropdown({
        prompt_title = 'Find Active Buffers',
        previewer = false,
      }))
    end, { desc = '[ ] Find active buffers' })

    -- Search (grep) functions
    -- Grep in current buffer
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({
        prompt_title = 'Search Current Buffer',
        previewer = false,
      }))
    end, { desc = '[/] Search Current buffer' })

    -- Grep in all currently active buffers
    vim.keymap.set('n', '<leader>sb', function()
      builtin.live_grep(themes.get_dropdown({
        prompt_title = 'Search Active Buffers',
        grep_open_files = true,opts = {path_display = { "truncate"}},
      }))
    end, { desc = 'Active [b]uffers' })

    -- Grep in all files in same dir as current buf
    vim.keymap.set('n', '<leader>sd', function()
      builtin.live_grep(themes.get_dropdown({
        prompt_title = 'Search Current Buffer Directory',
        grep_open_files = true,
        cwd = utils.buffer_dir(),
      }))
    end, { desc = 'Current buffer [d]irectory' })

    -- Search files in nvim dir
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files(themes.get_dropdown({
        previewer = false,
        prompt_title = 'Neovim Directory',
        cwd = vim.fn.stdpath('config'),
      }))
    end, { desc = '[N]eovim' })

    -- Search files in work git dir
    vim.keymap.set('n', '<leader>sg', function()
      builtin.find_files(themes.get_dropdown({ previewer = false, prompt_title = 'Git Projects Directory', cwd = '~/git' }))
    end, { desc = '[G]it' })

    require('telescope').setup({
      defaults = {
        path_display = { "truncate"}--shorten = {len = 1, exclude = {-1,-2}}},
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
