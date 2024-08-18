return {
  'coffebar/neovim-project',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope.nvim', tag = '0.1.*' },
    { 'Shatur/neovim-session-manager' },
  },
  opts = {
    projects = { -- define project roots
      '~/git/*',
      vim.fn.stdpath('config') .. '/*',
      '~/_daily-notes/*',
      '~/projects/*',
    },
    -- dashboard_mode = true,
  },
  init = function()
    -- enable saving the state of plugins in the session
    vim.opt.sessionoptions:append('globals') -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    vim.keymap.set('n', '<leader>Pf', ':Telescope neovim-project discover<cr>', { desc = '[F]ind projects' })
    vim.keymap.set('n', '<leader>P.', ':Telescope neovim-project history<cr>', { desc = '[.] Recent projects' })
    -- vim.keymap.set('n', '<leader>Pq', ':NeovimProjectLoadRecent<cr>', { desc = 'open the previous session.' })
    -- vim.keymap.set('n', '<leader>Px', ':NeovimProjectLoadHist<cr>', { desc = 'opens the project from the history providing a project dir.' })
    -- vim.keymap.set('n', '<leader>Pt', ':NeovimProjectLoad<cr>', { desc = 'opens the project from all your projects providing a project dir.' })
  end,
}
