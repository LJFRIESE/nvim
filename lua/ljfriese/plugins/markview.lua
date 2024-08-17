return {{
    "OXY2DEV/markview.nvim",
    event = 'VeryLazy',      -- Recommended
    -- ft = "markdown", -- If you decide to lazy-load anyway
    config = function()
    require("markview").setup({
        -- modes = { "n" }, -- Change these modes to what you need
        --
        -- hybrid_modes = { "c" },     -- Uses this feature on normal mode
        --
        -- -- This is nice to have
        -- callbacks = {
        --     on_enable = function (_, win)
        --         vim.wo[win].conceallevel = 2;
        --         vim.wo[win].conecalcursor = "c";
        --     end
        -- }
    })
    end

},{
    "OXY2DEV/helpview.nvim",
}}
