vim.pack.add({
	{src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{src =  "https://github.com/stevearc/oil.nvim",
    }
  
})

require("oil").setup({opts = {
        prompt_save_on_select_new_entry = false,
        skip_confirm_for_simple_edits = true,
        columns = { "icon", "size", "mtime" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
        },
        view_options = { show_hidden = true },
      } })
