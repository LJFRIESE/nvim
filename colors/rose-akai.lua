---@alias Palette { base: string, surface: string, overlay: string, muted: string, subtle: string, text: string, rose: string, gold: string, orange: string, ocean: string, sky: string, lilac: string }
---@alias PaletteColor "base" | "surface" | "overlay" | "muted" | "subtle" | "text" | "rose" | "gold" | "orange" | "ocean" | "sky" | "lilac" | "highlight_med" | "highlight_light"
---@alias Highlight { link: string, inherit: boolean } | { fg: string, bg: string, sp: string, bold: boolean, italic: boolean, undercurl: boolean, underline: boolean, underdouble: boolean, underdotted: boolean, underdashed: boolean, strikethrough: boolean, inherit: boolean }

local config = {}

---@class Options
config = {

  ---@type table<string, string>>
  palette = {
    none = 'NONE',
    base = '#1e1629',
    overlay = '#2a1f3a',
    highlight_dark = '#2a1f3a',
    highlight_med = '#36284a',
    highlight_light = '#42315b',
    muted = '#2e2e2e',
    subtle = '#797979',
    text = '#f8f0e7',
    ocean = '#6c99bb',
    gold = '#f6c177',
    orange = '#e87d3e',
    rose = '#ff6188',
    sky = '#9ccfd8',
    lilac = '#ab9df2',
    leaf = '#b4d273',
  },

  ---@type table<string, string | PaletteColor>
  groups = {
    border = 'gold',
    link = 'ocean',

    error = 'rose',
    hint = 'lilac',
    info = 'sky',
    note = 'ocean',
    todo = 'orange',
    warn = 'gold',

    git_add = 'sky',
    git_change = 'orange',
    git_delete = 'rose',
    git_dirty = 'orange',
    git_ignore = 'muted',
    git_merge = 'lilac',
    git_rename = 'ocean',
    git_stage = 'lilac',
    git_text = 'orange',
    git_untracked = 'subtle',

    ---@type string | PaletteColor
    h1 = 'lilac',
    h2 = 'sky',
    h3 = 'orange',
    h4 = 'gold',
    h5 = 'ocean',
    h6 = 'sky',
  },
  ---@type table<string, Highlight>
  highlight_groups = {},

}
local palette = config.palette

---@param options Options | nil
function config.extend_options(options)
  config = vim.tbl_deep_extend('force', config.options, options or {})
end

local utilities = {}

---@param color string
local function color_to_rgb(color)
  local function byte(value, offset)
    return bit.band(bit.rshift(value, offset), 0xFF)
  end

  local new_color = vim.api.nvim_get_color_by_name(color)
  if new_color == -1 then
    new_color = vim.opt.background:get() == 'dark' and 000 or 255255255
  end

  return { byte(new_color, 16), byte(new_color, 8), byte(new_color, 0) }
end

---@param color string Palette key or hex value
function utilities.parse_color(color)
  if color == nil then
    return print('Invalid color: ' .. color)
  end

  color = color:lower()

  if not color:find('#') and color ~= palette.none then
    color = palette[color] or vim.api.nvim_get_color_by_name(color)
  end

  return color
end

---@param fg string Foreground color
---@param bg string Background color
---@param alpha number Between 0 (background) and 1 (foreground)
function utilities.blend(fg, bg, alpha)
  local fg_rgb = color_to_rgb(fg)
  local bg_rgb = color_to_rgb(bg)

  local function blend_channel(i)
    local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end
  return string.format('#%02X%02X%02X', blend_channel(1), blend_channel(2), blend_channel(3))
end

local groups = {}
for group, color in pairs(config.groups) do
  groups[group] = utilities.parse_color(color)
end

local highlights = {}
local default_lightlights = {

  Normal = { bg = palette.base },

  NormalFloat = { bg = palette.overlay },
  FloatBorder = { fg = groups.border, bg = palette.overlay},
  FloatTitle = { fg = groups.border, bg = palette.overlay, bold = true },
  FloatcwFooter = { fg = palette.border },

  ColorColumn = { bg = palette.overlay },
  Conceal = { bg = palette.highlight_med },
  CurSearch = { fg = palette.base, bg = palette.gold },
  TermCursor = { fg = palette.text, bg = palette.sky },
  TermCursorNC = { fg = palette.text, bg = palette.none },
  iCursor = { fg = palette.text, bg = palette.sky },
  vCursor = { fg = palette.text, bg = palette.lilac },
  oCursor = { fg = palette.text, bg = palette.ocean },
  cCursor = { fg = palette.text, bg = palette.rose },
  Cursor = { fg = palette.text, bg = palette.leaf },
  CursorColumn = { bg = palette.highlight_med },
  -- CursorIM = {},
  CursorLine = { bg = palette.highlight_light },
  CursorLineNr = { fg = palette.text, bold = true },
  -- DarkenedPanel = { },
  -- DarkenedStatusline = {},
  DiffAdd = { bg = groups.git_add, blend = 20 },
  DiffChange = { bg = groups.git_change, blend = 20 },
  DiffDelete = { bg = groups.git_delete, blend = 20 },
  DiffText = { bg = groups.git_text, blend = 40 },
  diffAdded = { link = 'DiffAdd' },
  diffChanged = { link = 'DiffChange' },
  diffRemoved = { link = 'DiffDelete' },
  Directory = { fg = palette.sky, bold = true },
  ErrorMsg = { fg = groups.error, bold = true },
  FoldColumn = { fg = palette.muted },
  Folded = { fg = palette.text, bg = groups.overlay },
  IncSearch = { link = 'CurSearch' },
  LineNr = { fg = palette.subtle },
  MatchParen = { fg = palette.orange, blend = 0 },
  ModeMsg = { fg = palette.subtle },
  MoreMsg = { fg = palette.lilac },
  -- Virtual text like fold icon
  NonText = { fg = palette.orange, blend = 20 },
  NvimInternalError = { link = 'ErrorMsg' },
  Question = { fg = palette.gold },
  -- QuickFixLink = {},
  -- RedrawDebugNormal = {},
  RedrawDebugClear = { fg = palette.base, bg = palette.gold },
  RedrawDebugComposed = { fg = palette.base, bg = palette.ocean },
  RedrawDebugRecompose = { fg = palette.base, bg = palette.rose },
  Search = { link = 'IncSearch' },
  SignColumn = { fg = palette.text, bg = palette.none },
  SpecialKey = { fg = palette.sky },
  SpellBad = { sp = palette.subtle, undercurl = true },
  SpellCap = { sp = palette.subtle, undercurl = true },
  SpellLocal = { sp = palette.subtle, undercurl = true },
  SpellRare = { sp = palette.subtle, undercurl = true },
  Substitute = { link = 'IncSearch' },
  TabLine = { fg = palette.subtle, bg = groups.overlay },
  TabLineFill = { bg = groups.overlay },
  TabLineSel = { fg = palette.text, bg = palette.overlay, bold = true },
  Title = { fg = palette.sky, bold = true },
  VertSplit = { fg = groups.border },
  Visual = { bg = palette.highlight_med },
  WarningMsg = { fg = groups.warn, bold = true },
  WildMenu = { link = 'IncSearch' },
  WinBar = { fg = palette.subtle, bg = groups.overlay },
  WinBarNC = { fg = palette.muted, bg = groups.overlay, blend = 60 },
  WinSeparator = { fg = groups.border },

  DiagnosticError = { fg = groups.error },
  DiagnosticHint = { fg = groups.hint },
  DiagnosticInfo = { fg = groups.info },
  DiagnosticOk = { fg = groups.ok },
  DiagnosticWarn = { fg = groups.warn },
  DiagnosticDefaultError = { link = 'DiagnosticError' },
  DiagnosticDefaultHint = { link = 'DiagnosticHint' },
  DiagnosticDefaultInfo = { link = 'DiagnosticInfo' },
  DiagnosticDefaultOk = { link = 'DiagnosticOk' },
  DiagnosticDefaultWarn = { link = 'DiagnosticWarn' },
  DiagnosticFloatingError = { link = 'DiagnosticError' },
  DiagnosticFloatingHint = { link = 'DiagnosticHint' },
  DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
  DiagnosticFloatingOk = { link = 'DiagnosticOk' },
  DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignOk = { link = 'DiagnosticOk' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticUnderlineError = { sp = groups.error, undercurl = true },
  DiagnosticUnderlineHint = { sp = groups.hint, undercurl = true },
  DiagnosticUnderlineInfo = { sp = groups.info, undercurl = true },
  DiagnosticUnderlineOk = { sp = groups.ok, undercurl = true },
  DiagnosticUnderlineWarn = { sp = groups.warn, undercurl = true },
  DiagnosticVirtualTextError = { fg = groups.error },
  DiagnosticVirtualTextHint = { fg = groups.hint },
  DiagnosticVirtualTextInfo = { fg = groups.info },
  DiagnosticVirtualTextOk = { fg = groups.ok },
  DiagnosticVirtualTextWarn = { fg = groups.warn },

  Boolean = { fg = palette.orange },
  Character = { fg = palette.gold },
  Comment = { fg = palette.subtle, italic = true },
  Conditional = { fg = palette.rose },
  Constant = { fg = palette.rose, bold = true, italic = true },
  Debug = { fg = palette.orange },
  Define = { fg = palette.lilac },
  Delimiter = { fg = palette.subtle },
  Error = { fg = palette.rose },
  Exception = { fg = palette.rose },
  Function = { fg = palette.ocean },
  Identifier = { fg = palette.lilac },
  Include = { fg = palette.gold },
  Keyword = { fg = palette.rose },
  Label = { fg = palette.sky },
  LspInfoBorder = { fg = palette.gold },
  LspCodeLens = { fg = palette.subtle },
  LspCodeLensSeparator = { fg = palette.muted },
  LspInlayHint = { fg = palette.subtle, bg = palette.muted, blend = 10 },
  LspReferenceRead = { bg = palette.highlight_med },
  LspReferenceText = { bg = palette.highlight_med },
  LspReferenceWrite = { bg = palette.highlight_med },
  Macro = { fg = palette.lilac },
  Number = { fg = palette.orange },
  Operator = { fg = palette.subtle },
  PreCondit = { fg = palette.lilac },
  PreProc = { link = 'PreCondit' },
  Repeat = { fg = palette.ocean },
  Special = { fg = palette.orange, bold = true },
  SpecialChar = { link = 'Special' },
  SpecialComment = { fg = palette.lilac },
  Statement = { fg = palette.ocean, bold = true },
  StorageClass = { fg = palette.sky },
  String = { fg = palette.gold },
  Structure = { fg = palette.sky },
  Tag = { fg = palette.sky },
  Todo = { fg = palette.orange, bg = palette.rose, blend = 20 },
  Type = { fg = palette.lilac },
  TypeDef = { link = 'Type' },
  Underlined = { fg = palette.lilac, underline = true },

  healthError = { fg = groups.error },
  healthSuccess = { fg = groups.info },
  healthWarning = { fg = groups.warn },

  htmlArg = { fg = palette.lilac },
  htmlBold = { bold = true },
  htmlEndTag = { fg = palette.subtle },
  htmlH1 = { link = 'markdownH1' },
  htmlH2 = { link = 'markdownH2' },
  htmlH3 = { link = 'markdownH3' },
  htmlH4 = { link = 'markdownH4' },
  htmlH5 = { link = 'markdownH5' },
  htmlItalic = { italic = true },
  htmlLink = { link = 'markdownUrl' },
  htmlTag = { fg = palette.subtle },
  htmlTagN = { fg = palette.text },
  htmlTagName = { fg = palette.sky },

  markdownDelimiter = { fg = palette.subtle },
  markdownH1 = { fg = groups.h1, bold = true },
  markdownH1Delimiter = { link = 'markdownH1' },
  markdownH2 = { fg = groups.h2, bold = true },
  markdownH2Delimiter = { link = 'markdownH2' },
  markdownH3 = { fg = groups.h3, bold = true },
  markdownH3Delimiter = { link = 'markdownH3' },
  markdownH4 = { fg = groups.h4, italic = true },
  markdownH4Delimiter = { link = 'markdownH4' },
  markdownH5 = { fg = groups.h5, italic = true },
  markdownH5Delimiter = { link = 'markdownH5' },
  markdownH6 = { fg = groups.h6, italic = true },
  markdownH6Delimiter = { link = 'markdownH6' },
  markdownLinkText = { link = 'markdownUrl' },
  markdownUrl = { fg = palette.sky, italic = true, underline = true },
  mkdCode = { fg = palette.sky, italic = true },
  mkdCodeDelimiter = { fg = palette.orange },
  mkdCodeEnd = { fg = palette.sky },
  mkdCodeStart = { fg = palette.sky },
  mkdFootnotes = { fg = palette.sky },
  mkdID = { fg = palette.sky, underline = true },
  mkdInlineURL = { link = 'markdownUrl' },
  mkdLink = { link = 'markdownUrl' },
  mkdLinkDef = { link = 'markdownUrl' },
  mkdListItemLine = { fg = palette.text },
  mkdRule = { fg = palette.subtle },
  mkdURL = { link = 'markdownUrl' },

  --- Plugins

  -- lewis6991/gitsigns.nvim
  GitSignsAdd = { link = 'SignAdd' },
  GitSignsChange = { link = 'SignChange' },
  GitSignsDelete = { link = 'SignDelete' },
  SignAdd = { fg = groups.git_add, bg = palette.none },
  SignChange = { fg = groups.git_change, bg = palette.none },
  SignDelete = { fg = groups.git_delete, bg = palette.none },

  -- folke/which-key.nvim
  WhichKey = {link = 'String'},
  WhichKeyIcon = { fg = palette.ocean },

  --snacks/indent
  SnacksIndent = { fg = palette.muted },
  SnacksIndentScope = { fg = palette.subtle },
  SnacksIntentChunk = { fg = palette.orange },
  SnacksIntentBlank = { fg = palette.foam },

  -- Blink
  BlinkCmpSignatureHelp = { bg = palette.overlay}, --	The signature help window
  BlinkCmpSignatureHelpActiveParameter = { bg = palette.highlight_light },
  BlinkCmpDoc = { bg = palette.overlay },                            --  The documentation window
  BlinkCmpDocBorder = { fg = groups.border },
  BlinkCmpDocSeparator = { fg = groups.border },            --	The documentation separator between doc and detail
  BlinkCmpMenu = { bg = palette.overlay },                           --  The completion menu window
  BlinkCmpMenuBorder = { fg = groups.border },              --	The completion menu window border
  BlinkCmpMenuSelection = { bg = palette.highlight_light }, --	PmenuSel	The completion menu window selected item
  BlinkCmpGhostText = { link = 'NonText' },                 --	Preview item with ghost text
  BlinkCmpSource = {link = 'String'},                   --	Source of the completion item
  BlinkCmpKind = { link = 'String'},                     --	Kind icon/text of the completion item
  BlinkCmpLabel = { bg = palette.none },                          --  Label of the completion item
  BlinkCmpLabelMatch = {  link = 'String'},               --  Fuzzily matched characters
  BlinkCmpLabelDetail = { bg = palette.overlay },           --  Label description of the completion item
  BlinkCmpLabelDescription = { bg = palette.overlay },      --  Label description of the completion item
  BlinkCmpDocCursorLine = { bg = palette.highlight_light }, --	The documentation window cursor line

  -- rcarriga/nvim-dap-ui
  DapUIBreakpointsCurrentLine = { fg = palette.gold, bold = true },
  DapUIBreakpointsDisabledLine = { fg = palette.muted },
  DapUIBreakpointsInfo = { link = 'DapUIThread' },
  DapUIBreakpointsLine = { link = 'DapUIBreakpointsPath' },
  DapUIBreakpointsPath = { fg = palette.sky },
  DapUIDecoration = { link = 'DapUIBreakpointsPath' },
  DapUIFloatBorder = { fg = groups.border },
  DapUILineNumber = { link = 'DapUIBreakpointsPath' },
  DapUIModifiedValue = { fg = palette.sky, bold = true },
  DapUIScope = { link = 'DapUIBreakpointsPath' },
  DapUISource = { fg = palette.lilac },
  DapUIStoppedThread = { link = 'DapUIBreakpointsPath' },
  DapUIThread = { fg = palette.gold },
  DapUIValue = { fg = palette.text },
  DapUIVariable = { fg = palette.text },
  DapUIWatchesEmpty = { fg = palette.rose },
  DapUIWatchesError = { link = 'DapUIWatchesEmpty' },
  DapUIWatchesValue = { link = 'DapUIThread' },

  -- MiniStarterCurrent = { nocombine = true },
  -- MiniStarterFooter = { fg = palette.subtle },
  -- MiniStarterHeader = { link = 'Title' },
  -- MiniStarterInactive = { link = 'Comment' },
  -- MiniStarterItem = { link = 'Normal' },
  -- MiniStarterItemBullet = { link = 'Delimiter' },
  -- MiniStarterItemPrefix = { link = 'WarningMsg' },
  -- MiniStarterSection = { fg = palette.orange },
  -- MiniStarterQuery = { link = 'MoreMsg' },

  MiniStatuslineDevinfo = { fg = palette.subtle, bg = palette.overlay },
  MiniStatuslineFileinfo = { link = 'MiniStatuslineDevinfo' },
  MiniStatuslineFilename = { fg = palette.sky, bg = palette.overlay },
  MiniStatuslineInactive = { link = 'MiniStatuslineFilename' },
  MiniStatuslineModeCommand = { fg = palette.base, bg = palette.orange, bold = true },
  MiniStatuslineModeInsert = { fg = palette.base, bg = palette.ocean, bold = true },
  MiniStatuslineModeNormal = { fg = palette.base, bg = palette.leaf, bold = true },
  MiniStatuslineModeOther = { fg = palette.base, bg = palette.orange, bold = true },
  MiniStatuslineModeReplace = { fg = palette.base, bg = palette.ocean, bold = true },
  MiniStatuslineModeVisual = { fg = palette.base, bg = palette.lilac, bold = true },
  MiniSurround = { link = 'IncSearch' },

  -- nvim-treesitter/nvim-treesitter-context
  TreesitterContext = { bg = palette.base },
  TreesitterContextLineNumber = { fg = palette.subtle },

  --- Treesitter Identifiers
  ['@variable'] = { fg = palette.text },
  ['@variable.builtin'] = { link = 'Special' },
  ['@variable.parameter'] = { fg = palette.sky },
  ['@variable.member'] = { link = '@property'},

  ['@constant'] = { link = 'Constant' },
  ['@constant.builtin'] = { link = 'Special' },
  ['@constant.macro'] = { link = 'Macro' },

  ['@module'] = { link = 'Special' },
  ['@module.builtin'] = { link = 'Special' },
  ['@label'] = { link = 'Label' },

  --- Literals
  ['@string'] = { link = 'String' },
  -- ["@string.documentation"] = {},
  ['@string.regexp'] = { fg = palette.lilac },
  ['@string.escape'] = { fg = palette.ocean },
  ['@string.special'] = { link = 'String' },
  ['@string.special.symbol'] = { link = 'Identifier' },
  ['@string.special.url'] = { link = 'markdownURL' },
  ['@string.special.path'] = { link = 'markdownURL' },

  ['@character'] = { link = 'Character' },
  ['@character.special'] = { fg = palette.gold, italic = true },

  ['@boolean'] = { link = 'Boolean' },
  ['@number'] = { link = 'Number' },
  ['@number.float'] = { fg = palette.orange, italic = true },

  --- Types
  ['@type'] = { link = 'Type' },
  ['@type.builtin'] = { link = '@type' },
  ['@type.definition'] = { link = '@type' },

  ['@attribute'] = { fg = palette.lilac },
  ['@attribute.builtin'] = { link = '@attribute' },
  ['@property'] = { fg = palette.lilac },

  --- Functions
  ['@function'] = { link = 'Function' },
  ['@function.builtin'] = { fg = palette.ocean, bold = true },
  ['@function.call'] = { fg = palette.ocean, italic = true },
  ['@function.macro'] = { link = 'Macro' },
  ['@function.method'] = { link = 'Function' },
  ['@function.method.call'] = { link = '@function.call' },

  ['@constructor'] = { fg = palette.ocean },
  ['@operator'] = { link = 'Operator' },

  --- Keywords
  ['@keyword'] = { link = 'Keyword' },
  ['@keyword.coroutine'] = { fg = palette.rose, italic = true },
  ['@keyword.modifier'] = { fg = palette.rose, italic = true },
  ['@keyword.function'] = { link = 'Keyword' },
  ['@keyword.operator'] = { link = '@operator' },
  ['@keyword.import'] = { fg = palette.ocean },
  ['@keyword.storage'] = { fg = palette.sky },
  ['@keyword.repeat'] = { link = 'Keyword' },
  ['@keyword.return'] = { link = 'Conditional' },
  ['@keyword.debug'] = { link = 'Debug' },
  ['@keyword.exception'] = { link = 'Exception' },
  ['@keyword.conditional'] = { link = 'Conditional' },
  ['@keyword.conditional.ternary'] = { link = 'Conditional' },
  ['@keyword.directive'] = { fg = palette.orange, bold = true },

  --- Punctuation
  ['@punctuation.delimiter'] = { fg = palette.subtle },
  ['@punctuation.bracket'] = { fg = palette.subtle },
  ['@punctuation.special'] = { fg = palette.rose },

  --- Comments
  ['@comment'] = { link = 'Comment' },
  -- ["@comment.documentation"] = {},

  ['@comment.error'] = { fg = groups.error },
  ['@comment.warning'] = { fg = groups.warn },
  ['@comment.todo'] = { fg = groups.todo, bg = groups.todo, blend = 20 },
  ['@comment.hint'] = { fg = groups.hint, bg = groups.hint, blend = 20 },
  ['@comment.info'] = { fg = groups.info, bg = groups.info, blend = 20 },
  ['@comment.note'] = { fg = groups.note, bg = groups.note, blend = 20 },

  --- Markup
  ['@markup.strong'] = { bold = true },
  ['@markup.italic'] = { italic = true },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.underline'] = { underline = true },

  ['@markup.heading'] = { fg = palette.sky, bold = true },

  ['@markup.quote'] = { fg = palette.text },
  ['@markup.math'] = { link = 'Special' },
  ['@markup.environment'] = { link = 'Macro' },
  ['@markup.environment.name'] = { link = 'Type' },

  ['@markup.link'] = { link = 'markdownUrl' },
  ['@markup.link.url'] = { link = 'markdownUrl' },

  ['@markup.raw.markdown_inline'] = { bg = palette.highlight_med },
  ['@markup.raw.delimiter.markdown'] = { fg = palette.subtle, bg = palette.highlight_med  },

  ['@markup.list'] = { fg = palette.ocean },
  ['@markup.list.checked'] = { fg = palette.sky, bg = palette.foam, blend = 10 },
  ['@markup.list.unchecked'] = { fg = palette.text },

  -- Markdown headings
  ['@markup.heading.1'] = { link = 'markdownH1' },
  ['@markup.heading.2'] = { link = 'markdownH2' },
  ['@markup.heading.3'] = { link = 'markdownH3' },
  ['@markup.heading.4'] = { link = 'markdownH4' },
  ['@markup.heading.5'] = { link = 'markdownH5' },
  ['@markup.heading.6'] = { link = 'markdownH6' },
  ['@diff.plus'] = {link = 'DiffAdd' }, -- fg = groups.git_add, bg = groups.git_add, blend = 20 },
  ['@diff.minus'] = { link = 'DiffDelete' },-- fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
  ['@diff.delta'] = { link = 'DiffChange' },

  ['@tag'] = { link = 'Tag' },
  ['@tag.attribute'] = { fg = palette.lilac },
  ['@tag.delimiter'] = { fg = palette.subtle },

  --- Non-highlighting captures
  ['@conceal'] = { link = 'Conceal' },
  ['@conceal.markdown'] = { fg = palette.subtle },

  --- LSP Semantic tokens
  ['@lsp.type.type'] = { link = 'Type' },
  ['@lsp.type.enum'] = { link = '@Type' },
  ['@lsp.type.interface'] = { fg = palette.orange },
  ['@lsp.type.struct'] = { fg = palette.orange },
  ['@lsp.type.keyword'] = { link = 'Keyword' },
  ['@lsp.type.namespace'] = { link = 'Include' },
  ['@lsp.type.parameter'] = { link = '@variable.parameter' },
  ['@lsp.type.function'] = { link = 'Function' },
  ['@lsp.type.method'] = { link = 'Function' },

  ['@lsp.mod.documentation'] = { link = 'Comment' },
  ['@lsp.mod.defaultLibrary'] = { fg = palette.lilac },
  ['@lsp.mod.global'] = { italic = true, bold = true },
  ['@lsp.mod.definition'] = { italic = true, bold = true },
}

for group, highlight in pairs(default_lightlights) do
  highlights[group] = highlight
end

-- Reconcile highlights with config
if config.highlight_groups ~= nil and next(config.highlight_groups) ~= nil then
  for group, highlight in pairs(config.highlight_groups) do
    local existing = highlights[group] or {}
    -- Traverse link due to
    -- "If link is used in combination with other attributes; only the link will take effect"
    -- see: https://neovim.io/doc/user/api.html#nvim_set_hl()
    while existing.link ~= nil do
      existing = highlights[existing.link] or {}
    end
    local parsed = vim.tbl_extend('force', {}, highlight)

    if highlight.fg ~= nil then
      parsed.fg = utilities.parse_color(highlight.fg) or highlight.fg
    end
    if highlight.bg ~= nil then
      parsed.bg = utilities.parse_color(highlight.bg) or highlight.bg
    end
    if highlight.sp ~= nil then
      parsed.sp = utilities.parse_color(highlight.sp) or highlight.sp
    end

    if (highlight.inherit == nil or highlight.inherit) and existing ~= nil then
      parsed.inherit = nil
      highlights[group] = vim.tbl_extend('force', existing, parsed)
    else
      parsed.inherit = nil
      highlights[group] = parsed
    end
  end
end

for group, highlight in pairs(highlights) do
  if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
    highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
  end
  vim.api.nvim_set_hl(0, group, highlight)
end
