return {
  {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost', -- later will not save folds
    opts = {setupFoldKeymaps = false},
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'UIEnter', -- needed for folds to load in time and comments closed
			 keys = {
			-- stylua: ignore start
			{ "zm", function() require("ufo").closeAllFolds() end, desc = "󱃄 Close All Folds" },
			{ "zr", function()
				require("ufo").openFoldsExceptKinds { "comment", "imports" }
				vim.opt.scrolloff = vim.g.baseScrolloff -- fix scrolloff setting sometimes being off
			end, desc = "󱃄 Open All Regular Folds" },
			-- { "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = "󱃄 Open All Folds" },
			 },
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = {
      provider_selector = function(_, ft, _)
        -- INFO some filetypes only allow indent, some only LSP, some only
        -- treesitter. However, ufo only accepts two kinds as priority,
        -- therefore making this function necessary :/
        local lspWithOutFolding = { 'quarto', 'markdown', 'sh', 'css', 'html', 'python', 'json' }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { 'treesitter', 'indent' }
        end
        return { 'lsp', 'indent' }
      end,
      -- when opening the buffer, close these fold kinds
      -- use `:UfoInspect` to get available fold kinds from the LSP
      close_fold_kinds_for_ft = {
        default = { },
      },
      open_fold_hl_timeout = 800,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local hlgroup = 'NonText'
        local newVirtText = {}
        local suffix = '   ' .. tostring(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, hlgroup })
        return newVirtText
      end,
    },
  },
}
