return{
    { 'LJFRIESE/colorscheme',
    config = function()
        local config = require("rose-pine.config")
        local utilities = require("rose-pine.utilities")
        local palette = {
            _nc = "#f8f0e7",
            base = "#2e2e2e",
            surface = "#272a30",
            overlay = "#4d5154",
            muted = "#2e323C",
            subtle = "#797979",
            text = "#fcfcfa",
            love = "#ff6188",
            gold = "#f6c177",
            rose = "#e87d3e",
            pine = "#78dce8",
            foam = "#9ccfd8",
            iris = "#ab9df2",
            leaf = "#a9dc76",
            highlight_low = "#21202e",
            highlight_med = "#403d52",
            highlight_high = "#524f67",
            none = "none",
        }
        local styles = config.options.styles

        local groups = {}
        for group, color in pairs(config.options.groups) do
            groups[group] = utilities.parse_color(color)
        end
        require("rose-pine").setup({

            dim_inactive_windows = false,
            extend_background_behind_borders = true,

            enable = {
                terminal = true,
                legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                migrations = true, -- Handle deprecated options automatically
            },

            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },

            groups = {
                border = "gold",
                link = "iris",
                panel = "surface",

                error = "love",
                hint = "iris",
                info = "foam",
                note = "pine",
                todo = "rose",
                warn = "gold",

                git_add = "foam",
                git_change = "rose",
                git_delete = "love",
                git_dirty = "rose",
                git_ignore = "muted",
                git_merge = "iris",
                git_rename = "pine",
                git_stage = "iris",
                git_text = "rose",
                git_untracked = "subtle",

                h1 = "iris",
                h2 = "foam",
                h3 = "rose",
                h4 = "gold",
                h5 = "pine",
                h6 = "foam",
            },
            highlight_groups = {
                --- Functions
                ["@function"] = { fg = palette.pine },
                ["@function.builtin"] = { fg = palette.love, bold = styles.bold },
                ["@function.call"] = {fg = palette.leaf},
                ["@function.macro"] = { link = "Function" },
                ["@function.method"] = { fg = palette.leaf },
                ["@function.method.call"] = { fg = palette.foam},

                --- Types
                ["@type"] = { fg = palette.foam },
                ["@type.builtin"] = { fg = palette.foam, bold = styles.bold },

                ["@boolean"] = { fg = palette.rose },
                ["@number"] = { fg = palette.rose },
                ["@number.float"] = { fg = palette.rose },

                -- ["@attribute"] = {},
                ["@property"] = { fg = palette.iris, italic = styles.italic },

                --- Keywords
                Keyword = { fg = palette.love },
                ["@keyword.function"] = {fg = palette.foam},
                ["@keyword.exception"] = {fg = palette.love},

                CursorLine = { bg = palette.surface },
                -- Operator = { fg = palette.love },
                MatchParen = { fg = palette.muted, bg = palette.leaf, blend = 100},

                CursorLineNr = { fg = palette.text},
                LineNr = { fg = palette.subtle },

                -- TreesitterContext = { bg = palette.base },
                TreesitterContextLineNumber = { fg = palette.subtle },

                IblIndent = { fg = palette.muted },
                IblScope = { fg = palette.subtle},
                IblWhitespace = { fg = palette.rose},

                MiniStatuslineDevinfo = { fg = palette.subtle, bg = palette.base },
                MiniStatuslineFileinfo = { link = "MiniStatuslineDevinfo" },
                MiniStatuslineFilename = { fg = palette.subtle, bg = palette.base },
                MiniStatuslineInactive = { link = "MiniStatuslineFilename" },
                MiniStatuslineModeCommand = { fg = palette.base, bg = palette.rose, bold = styles.bold },
                MiniStatuslineModeInsert = { fg = palette.base, bg = palette.pine, bold = styles.bold },
                MiniStatuslineModeNormal = { fg = palette.base, bg = palette.leaf, bold = styles.bold },
                MiniStatuslineModeOther = { fg = palette.base, bg = palette.rose, bold = styles.bold },
                MiniStatuslineModeReplace = { fg = palette.base, bg = palette.pine, bold = styles.bold },
                MiniStatuslineModeVisual = { fg = palette.base, bg = palette.iris, bold = styles.bold },
            },

            before_highlight = function(group, highlight, palette)
                -- Disable all undercurls
                -- if highlight.undercurl then
                --     highlight.undercurl = false
                -- end
                --
                -- Change palette colour
                -- if highlight.fg == palette.pine then
                --     highlight.fg = palette.foam
                -- end
            end,

        })
        vim.cmd("colorscheme rose-pine")
    end},
    { 'tanvirtin/monokai.nvim'},
}
