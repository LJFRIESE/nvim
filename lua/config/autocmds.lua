-- Highlight yanked text
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 100,
        })
    end,
})

-- Search for word under cursor
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = yank_group,
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

-- Use 'q' to close special buffer types. '' catches a lot of transient plugin windows.
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype
        local types = { 'help', 'fugitive', 'checkhealth', 'vim', '' }
        for _, b in ipairs(types) do
            if filetype == b then
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
                    callback = function()
                        vim.api.nvim_command('close')
                    end,
                })
            end
        end
    end,
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
-- If don't do this on `FileType`, this keeps reappearing due to being set in
-- filetype plugins.
local formatGroup = vim.api.nvim_create_augroup('Formatting', {})
vim.api.nvim_create_autocmd('FileType', {
    group = formatGroup,
    callback = function()
        vim.cmd('setlocal formatoptions-=c formatoptions-=o')
    end,
    desc = [[Ensure proper 'formatoptions']],
})

-- Lint on save
-- vim.api.nvim_create_autocmd({ 'BufReadPre', 'TextChanged' }, {
--   group = formatGroup,
--   callback = function()
--     require('lint').try_lint()
--   end,
-- })

-- Format command
vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
end, { range = true })

-- Folding lsp
vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)


        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
    end,
})


vim.opt.fillchars:append({ foldclose = '', fold = " " })
local function fold_virt_text(result, s, lnum, coloff)
    if not coloff then
        coloff = 0
    end
    local text = ""
    local hl
    for i = 1, #s do
        local char = s:sub(i, i)
        local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
        local _hl = hls[#hls]
        if _hl then
            local new_hl = "@" .. _hl.capture
            if new_hl ~= hl then
                table.insert(result, { text, hl })
                text = ""
                hl = nil
            end
            text = text .. char
            hl = new_hl
        else
            text = text .. char
        end
    end
    table.insert(result, { text, hl })
end

function _G.custom_foldtext()
    local start = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
    local n_lines = vim.v.foldend - vim.v.foldstart
    local result = {}
    fold_virt_text(result, start, vim.v.foldstart)
    table.insert(result, { "  " .. n_lines, "Special" })
    return result
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
    end,
})


vim.api.nvim_create_autocmd('LspProgress', {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        vim.notify(vim.lsp.status(), 'info', {
            id = 'lsp_progress',
            title = 'LSP Progress',
            opts = function(notif)
                notif.icon = ev.data.params.value.kind == 'end' and ' ' or
                    spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})

-- Open trouble when quickfix is opened
-- add cmd :ccl to also auto-close the qf buf. Not sure if I want to yet...
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    callback = function()
        vim.cmd([[Trouble qflist open]])
        vim.cmd([[ccl]])
    end,
})

-- Set nowrap if window is left than textwidth
vim.api.nvim_create_autocmd('WinResized', {
    pattern = '*',
    callback = function()
        local win_width = vim.api.nvim_win_get_width(0)
        local text_width = vim.opt.textwidth._value
        local wide_enough = win_width < text_width + 1
        vim.api.nvim_set_option_value('wrap', wide_enough, {})
    end,
})

--- Center when inserting
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        local debounce = 8
        if vim.fn.abs(vim.fn.line('.') - math.floor(vim.fn.line('w0') + vim.fn.winheight(0) / 2)) >= debounce then
            vim.cmd('norm! zz')
        end
    end,
})


local function update_global_mark()
    -- Get all marks
    local marks = vim.fn.getmarklist()
    local current_buf_name = vim.fn.expand('%:p')
    -- Look for global marks (A-Z) in current buffer
    for _, mark_info in ipairs(marks) do
        -- Normalize mark path
        local mark_file = vim.fn.fnamemodify(mark_info.file, ':p')
        -- Extract just the letter from the mark
        local mark_char = mark_info.mark:sub(2)
        -- Check if mark is global (A-Z) and in current buffer
        if mark_file == current_buf_name and mark_char:match('%u$') then
            -- Update the mark to current cursor position
            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_buf_set_mark(0, mark_char, cursor_pos[1], cursor_pos[2], {})
            return -- Exit after updating the first matching mark
        end
    end
end

-- Update global mark when leaving buffer
vim.api.nvim_create_autocmd('BufLeave', {
    pattern = '*',
    callback = update_global_mark,
})

---------------
-- Bookmarks --
---------------

-- Cache for storing buffer bookmark information
_G.file_bookmarks = {}

local notification_timer = vim.uv.new_timer()

-- Convert a character (A-I) to its corresponding mark number (1-9)
local function char2mark(char)
    return char:byte() - 64
end

-- Convert a mark number (1-9) to its corresponding character (A-I)
local function mark2char(mark)
    if mark:match("[1-9]") then
        return string.char(mark + 64)
    end
    return mark
end

-- Display a notification message
local function bookmark_notification(msg)
    if notification_timer then
        notification_timer:stop()
    end

    vim.api.nvim_echo({ { msg, "BookmarkNotification" } }, false, {})
    notification_timer:start(3000, 0, function()
        notification_timer:stop() -- Reset the timer
        vim.schedule(function()
            vim.api.nvim_echo({}, false, {})
        end)
    end)
end

local function check_bookmark(mark)
    if _G.file_bookmarks[mark] then
        return true
    end
    return false
end

-- Delete any bookmark from the current buffer
local function delete_bookmark(mark)
    if mark then
        mark = char2mark(mark)
    else
        mark = vim.fn.getcharstr()
    end
    if check_bookmark(mark) then
        vim.api.nvim_del_mark(mark2char(mark))
        _G.file_bookmarks[mark] = nil
        bookmark_notification("Delete mark #" .. mark)
    else
        bookmark_notification("Mark #" .. mark .. " not set")
    end
end

-- Delete all bookmarks accross all buffers
local function delete_all_bookmarks()
    bookmark_notification("Delete all bookmarks")
    vim.cmd("delmarks A-I")
    _G.file_bookmarks = {}
end

-- This overwrites default behaviour for setting marks 1-9 using m, but it leaves
-- all other uses unimpaired. Marks 1-9 are by default the location of the cursor at
-- the nth previous time that vim was closed.
--
-- This overrides the behaviour for m[1-9] and sets the corresponding alpha (A-I) as a
-- global mark. Jumping to mark 1-9 gets redirected to this alpha mark.
vim.keymap.set("n", "m", function()
    local mark = vim.fn.getcharstr()
    local char = mark2char(mark)
    vim.cmd("mark " .. char)
    if mark:match("[1-9]") then
        if check_bookmark(mark) then
            bookmark_notification("Mark #" .. mark .. " updated")
        else
            _G.file_bookmarks[mark] = char
            bookmark_notification("Mark #" .. mark .. " set")
        end
    else
        vim.fn.feedkeys("m" .. mark, "n")
    end
end, { desc = "Set mark or handle custom marks" })

-- This overwrites default behaviour for jumping to marks 1-9 using ', but it leaves
-- default behaviour intact using `. All other uses of ' are unimpaired.
--
-- This overrides the behaviour for '[1-9] and jumps to the corresponding alpha (A-I).
vim.keymap.set("n", "'", function()
    local mark = vim.fn.getcharstr()
    vim.fn.feedkeys("'" .. mark2char(mark), "n")
    if mark:match("[1-9]") then
        if check_bookmark(mark) then
            bookmark_notification("Jump to mark #" .. mark)
        else
            bookmark_notification("Mark #" .. mark .. " not set")
        end
    end
end)

-- Delete mark from current buffer
-- The [1-9] index of the bookmark to be deleted must be typed after this keymap.
vim.keymap.set("n", "<leader>md", delete_bookmark, { desc = "Delete bookmark" })

-- Delete all global marks
vim.keymap.set("n", "<leader>mD", delete_all_bookmarks, { desc = "Delete all bookmarks" })

local function list_bookmarks()
    local snacks = require("snacks")
    return snacks.picker.marks({
        layout = {
            preview = true,
            layout = {
                backdrop = false,
                width = 0.5,
                max_width = 80,
                height = 0.4,
                min_height = 3,
                box = "horizontal",
                border = "rounded",
                title = "{title}",
                title_pos = "center",
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", width = 0.6, border = "right" },
            },
        },
        transform = function(item)
            if item.label and item.label:match("^[A-I]$") and item then
                item.label = "" .. string.byte(item.label) - string.byte("A") + 1 .. ""
                item.file = vim.fn.fnamemodify(item.file, ':t')
                return item
            end
            return false
        end,
    })
end


-- Populate and open quickfix list with all bookmarks
vim.keymap.set("n", "<leader>mm", list_bookmarks, { desc = "List all bookmarks" })
