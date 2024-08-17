-- Global variables.
vim.g.projects_dir = vim.env.HOME .. '/projects'
-- vim.g.personal_projects_dir = vim.g.projects_dir .. '/Personal'
vim.g.mapleader = ' '

-- Set my colorscheme.
vim.cmd.colorscheme 'rose-akai'

--Install lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  ui = {
    border = "rounded",
    title = "Lazy",
  },
  spec = 'ljfriese/plugins',
  change_detection = { notify = false },
  performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})


-- local md_namespace = vim.api.nvim_create_namespace('mariasolos/lsp_float')
    --- Adds extra inline highlights to the given buffer.
    ---@param buf integer
    -- local function add_inline_highlights(buf)
    --   for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    --     for pattern, hl_group in pairs({
    --       ['@%S+'] = '@parameter',
    --       ['^%s*(Parameters:)'] = '@text.title',
    --       ['^%s*(Return:)'] = '@text.title',
    --       ['^%s*(See also:)'] = '@text.title',
    --       ['{%S-}'] = '@parameter',
    --       ['|%S-|'] = '@text.reference',
    --     }) do
    --       local from = 1 ---@type integer?
    --       while from do
    --         local to
    --         from, to = line:find(pattern, from)
    --         if from then
    --           vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
    --             end_col = to,
    --             hl_group = hl_group,
    --           })
    --         end
    --         from = to and to + 1 or nil
    --       end
    --     end
    --   end
    -- end
    -- --- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
    -- ---@param bufnr integer
    -- ---@param contents string[]
    -- ---@param opts table
    -- ---@return string[]
    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    --   contents = vim.lsp.util._normalize_markdown(contents, {
    --     width = vim.lsp.util._make_floating_popup_size(contents, opts),
    --   })
    --   vim.bo[bufnr].filetype = 'markdown'
    --   vim.treesitter.start(bufnr)
    --   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)
    --
    --   add_inline_highlights(bufnr)
    --
    --   return contents
    -- end
    --
