return { -- nuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'UIEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
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
    vim.keymap.set('n', '<leader>sb', builtin.builtin, { desc = '[B]uiltin Telescopes' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'current [W]ord' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = '[R]egisters' })
    -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[R]esume' })
    -- vim.keymap.set('n', '<leader>spp', function() builtin.planets({show_pluto = true, show_moon = true}) end, { desc = '[R]esume' })

    vim.keymap.set('n', '<leader>sp', builtin.git_files, { desc = '[P]roject files' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Global [F]iles' })
    vim.keymap.set('n', '<leader>s.', function()
      builtin.oldfiles(themes.get_dropdown({prompt_title = 'Recent Files',  cwd = utils.buffer_dir(), previewer = false }))
    end, { desc = '[.] Recent Files' })
    vim.keymap.set('n', '<leader>sl', function()
      builtin.find_files(themes.get_dropdown({ prompt_title = 'Local Files',cwd = utils.buffer_dir(), previewer = false }))
    end, { desc = '[L]ocal Files' })
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers(themes.get_dropdown({ prompt_title = 'Active Buffers',previewer = false }))
    end, { desc = '[ ] Find active buffers' })

    -- Grep in current buffer
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(themes.get_dropdown({ prompt_title = 'Search Current Buffer',previewer = false }))
    end, { desc = '[/] Grep current buffer' })
    -- Grep in all currently active buffers
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep(themes.get_dropdown({ prompt_title = 'Search Active Buffers',grep_open_files = true }))
    end, { desc = '[/] Grep active buffers' })
    -- Grep in all files in same dir as current buf
    vim.keymap.set('n', '<leader>sg', function()
      builtin.live_grep(themes.get_dropdown({ prompt_title = 'Search All Files in Current Directory',grep_open_files = true, cwd = utils.buffer_dir() }))
    end, { desc = '[G]rep current directory' })

    -- Search files in nvim dir
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files({ prompt_title = 'Neovim Directory',cwd = vim.fn.stdpath('config') })
    end, { desc = '[N]eovim' })
    require('telescope').setup({
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
