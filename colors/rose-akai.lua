---@alias Palette { base: string, surface: string, overlay: string, muted: string, subtle: string, text: string, love: string, gold: string, rose: string, pine: string, foam: string, iris: string }
---@alias PaletteColor "base" | "surface" | "overlay" | "muted" | "subtle" | "text" | "love" | "gold" | "rose" | "pine" | "foam" | "iris" | "highlight_low" | "highlight_med" | "highlight_high"
---@alias Highlight { link: string, inherit: boolean } | { fg: string, bg: string, sp: string, bold: boolean, italic: boolean, undercurl: boolean, underline: boolean, underdouble: boolean, underdotted: boolean, underdashed: boolean, strikethrough: boolean, inherit: boolean }

local config = {}

---@class Options
config = {
  ---Differentiate between active and inactive windows and panels.
  dim_inactive_windows = false,

  ---Extend background behind borders. Appearance differs based on which
  ---border characters you are using.
  extend_background_behind_borders = true,

  enable = {
    terminal = true,
  },

  styles = {
    bold = true,
    italic = true,
    transparency = true,
  },

  ---@type table<string, string>>
  palette = {
    _nc = '#f8f0e7',
    base = '#2e2e2e',
    surface = '#4d5154',
    overlay = '#272a30',
    muted = '#2e323C',
    subtle = '#797979',
    text = '#fcfcfa',
    love = '#ff6188',
    gold = '#f6c177',
    rose = '#e87d3e',
    pine = '#78dce8',
    foam = '#9ccfd8',
    iris = '#ab9df2',
    leaf = '#a9dc76',
    highlight_low = '#21202e',
    highlight_med = '#403d52',
    highlight_high = '#524f67',
    none = 'none',
  },

  ---@type table<string, string | PaletteColor>
  groups = {
    border = 'gold',
    link = 'iris',
    panel = 'surface',

    error = 'love',
    hint = 'iris',
    info = 'foam',
    note = 'pine',
    todo = 'rose',
    warn = 'gold',

    git_add = 'foam',
    git_change = 'rose',
    git_delete = 'love',
    git_dirty = 'rose',
    git_ignore = 'muted',
    git_merge = 'iris',
    git_rename = 'pine',
    git_stage = 'iris',
    git_text = 'rose',
    git_untracked = 'subtle',

    ---@type string | PaletteColor
    h1 = 'iris',
    h2 = 'foam',
    h3 = 'rose',
    h4 = 'gold',
    h5 = 'pine',
    h6 = 'foam',
  },
  ---@type table<string, Highlight>
  highlight_groups = {},

  ---Called before each highlight group, before setting the highlight.
  ---@param group string
  ---@param highlight Highlight
  ---@param palette Palette
  ---@diagnostic disable-next-line: unused-local
  before_highlight = function(group, highlight, palette)
    -- Disable all undercurls
    if highlight.undercurl then
      highlight.undercurl = false
    end
  end,
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

  if not color:find('#') and color ~= 'NONE' then
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
local styles = config.styles

local groups = {}
for group, color in pairs(config.groups) do
  groups[group] = utilities.parse_color(color)
end

local function make_border(fg)
  fg = fg or groups.border
  return {
    fg = fg,
    bg = (config.extend_background_behind_borders and not styles.transparency) and palette.surface or 'NONE',
  }
end

local highlights = {}
-- Treesitter highlights first, then lsp groups follow
local default_highlights = {
  ColorColumn = { bg = palette.overlay },
  Conceal = { bg = 'NONE' },
  CurSearch = { fg = palette.base, bg = palette.gold },
  Cursor = { fg = palette.text, bg = palette.foam },
  CursorColumn = { bg = palette.overlay },
  -- CursorIM = {},
  CursorLine = { bg = palette.overlay },
  CursorLineNr = { fg = palette.text, bold = styles.bold },
  -- DarkenedPanel = { },
  -- DarkenedStatusline = {},
  DiffAdd = { bg = groups.git_add, blend = 20 },
  DiffChange = { bg = groups.git_change, blend = 20 },
  DiffDelete = { bg = groups.git_delete, blend = 20 },
  DiffText = { bg = groups.git_text, blend = 40 },
  diffAdded = { link = 'DiffAdd' },
  diffChanged = { link = 'DiffChange' },
  diffRemoved = { link = 'DiffDelete' },
  Directory = { fg = palette.foam, bold = styles.bold },
  -- EndOfBuffer = {},
  ErrorMsg = { fg = groups.error, bold = styles.bold },
  FloatBorder = { fg = groups.border },
  FloatcwFooter = { fg = palette.gold },
  FloatTitle = { fg = palette.gold },
  FoldColumn = { fg = palette.muted },
  Folded = { fg = palette.text, bg = groups.panel },
  IncSearch = { link = 'CurSearch' },
  LineNr = { fg = palette.subtle },
  MatchParen = { fg = palette.rose, bg = 'NONE', blend = 0 },
  ModeMsg = { fg = palette.subtle },
  MoreMsg = { fg = palette.iris },
  -- Virtual text like fold icon
  NonText = { fg = palette.rose, blend = 20 },
  Normal = { fg = palette.text, bg = palette.base },
  NormalFloat = { bg = groups.muted },
  NormalNC = { fg = palette.text, bg = config.dim_inactive_windows and palette._nc or palette.base },
  NvimInternalError = { link = 'ErrorMsg' },
  Pmenu = { fg = palette.subtle, bg = groups.panel },
  PmenuExtra = { fg = palette.muted, bg = groups.panel },
  PmenuExtraSel = { fg = palette.subtle, bg = palette.overlay },
  PmenuKind = { fg = palette.foam, bg = groups.panel },
  PmenuKindSel = { fg = palette.subtle, bg = palette.overlay },
  PmenuSbar = { bg = groups.panel },
  PmenuSel = { fg = palette.text, bg = palette.overlay },
  PmenuThumb = { bg = palette.muted },
  Question = { fg = palette.gold },
  -- QuickFixLink = {},
  -- RedrawDebugNormal = {},
  RedrawDebugClear = { fg = palette.base, bg = palette.gold },
  RedrawDebugComposed = { fg = palette.base, bg = palette.pine },
  RedrawDebugRecompose = { fg = palette.base, bg = palette.love },
  Search = { link = 'IncSearch' },
  SignColumn = { fg = palette.text, bg = 'NONE' },
  SpecialKey = { fg = palette.foam },
  SpellBad = { sp = palette.subtle, undercurl = true },
  SpellCap = { sp = palette.subtle, undercurl = true },
  SpellLocal = { sp = palette.subtle, undercurl = true },
  SpellRare = { sp = palette.subtle, undercurl = true },
  StatusLine = { fg = palette.subtle, bg = groups.panel },
  StatusLineNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
  StatusLineTerm = { fg = palette.base, bg = palette.pine },
  StatusLineTermNC = { fg = palette.base, bg = palette.pine, blend = 60 },
  Substitute = { link = 'IncSearch' },
  TabLine = { fg = palette.subtle, bg = groups.panel },
  TabLineFill = { bg = groups.panel },
  TabLineSel = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
  Title = { fg = palette.foam, bold = styles.bold },
  VertSplit = { fg = groups.border },
  Visual = { bg = palette.highlight_med },
  -- VisualNOS = {},
  WarningMsg = { fg = groups.warn, bold = styles.bold },
  -- Whitespace = {},
  WildMenu = { link = 'IncSearch' },
  WinBar = { fg = palette.subtle, bg = groups.panel },
  WinBarNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
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
  DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 },
  DiagnosticVirtualTextHint = { fg = groups.hint, bg = groups.hint, blend = 10 },
  DiagnosticVirtualTextInfo = { fg = groups.info, bg = groups.info, blend = 10 },
  DiagnosticVirtualTextOk = { fg = groups.ok, bg = groups.ok, blend = 10 },
  DiagnosticVirtualTextWarn = { fg = groups.warn, bg = groups.warn, blend = 10 },

  Boolean = { fg = palette.rose },
  Character = { fg = palette.gold },
  Comment = { fg = palette.subtle, italic = styles.italic },
  Conditional = { fg = palette.pine },
  Constant = { fg = palette.gold },
  Debug = { fg = palette.rose },
  Define = { fg = palette.iris },
  Delimiter = { fg = palette.subtle },
  Error = { fg = palette.love },
  Exception = { fg = palette.pine },
  Float = { fg = palette.gold },
  Function = { fg = palette.pine },
  Identifier = { fg = palette.iris },
  Include = { fg = palette.pine },
  Keyword = { fg = palette.love },
  Label = { fg = palette.foam },
  LspInfoBorder = { fg = palette.gold },
  LspCodeLens = { fg = palette.subtle },
  LspCodeLensSeparator = { fg = palette.muted },
  LspInlayHint = { fg = palette.muted, bg = palette.muted, blend = 10 },
  LspReferenceRead = { bg = palette.highlight_med },
  LspReferenceText = { bg = palette.highlight_med },
  LspReferenceWrite = { bg = palette.highlight_med },
  Macro = { fg = palette.iris },
  Number = { fg = palette.rose },
  Operator = { fg = palette.subtle },
  PreCondit = { fg = palette.iris },
  PreProc = { link = 'PreCondit' },
  Repeat = { fg = palette.pine },
  Special = { fg = palette.rose },
  SpecialChar = { link = 'Special' },
  SpecialComment = { fg = palette.iris },
  Statement = { fg = palette.pine, bold = styles.bold },
  StorageClass = { fg = palette.foam },
  String = { fg = palette.gold },
  Structure = { fg = palette.foam },
  Tag = { fg = palette.foam },
  Todo = { fg = palette.rose, bg = palette.rose, blend = 20 },
  Type = { fg = palette.foam },
  TypeDef = { link = 'Type' },
  Underlined = { fg = palette.iris, underline = true },

  healthError = { fg = groups.error },
  healthSuccess = { fg = groups.info },
  healthWarning = { fg = groups.warn },

  htmlArg = { fg = palette.iris },
  htmlBold = { bold = styles.bold },
  htmlEndTag = { fg = palette.subtle },
  htmlH1 = { link = 'markdownH1' },
  htmlH2 = { link = 'markdownH2' },
  htmlH3 = { link = 'markdownH3' },
  htmlH4 = { link = 'markdownH4' },
  htmlH5 = { link = 'markdownH5' },
  htmlItalic = { italic = styles.italic },
  htmlLink = { link = 'markdownUrl' },
  htmlTag = { fg = palette.subtle },
  htmlTagN = { fg = palette.text },
  htmlTagName = { fg = palette.foam },

  markdownDelimiter = { fg = palette.subtle },
  markdownH1 = { fg = groups.h1, bold = styles.bold },
  markdownH1Delimiter = { link = 'markdownH1' },
  markdownH2 = { fg = groups.h2, bold = styles.bold },
  markdownH2Delimiter = { link = 'markdownH2' },
  markdownH3 = { fg = groups.h3, bold = styles.bold },
  markdownH3Delimiter = { link = 'markdownH3' },
  markdownH4 = { fg = groups.h4, bold = styles.bold },
  markdownH4Delimiter = { link = 'markdownH4' },
  markdownH5 = { fg = groups.h5, bold = styles.bold },
  markdownH5Delimiter = { link = 'markdownH5' },
  markdownH6 = { fg = groups.h6, bold = styles.bold },
  markdownH6Delimiter = { link = 'markdownH6' },
  markdownLinkText = { link = 'markdownUrl' },
  markdownUrl = { fg = groups.link, sp = groups.link, underline = true },

  mkdCode = { fg = palette.foam, italic = styles.italic },
  mkdCodeDelimiter = { fg = palette.rose },
  mkdCodeEnd = { fg = palette.foam },
  mkdCodeStart = { fg = palette.foam },
  mkdFootnotes = { fg = palette.foam },
  mkdID = { fg = palette.foam, underline = true },
  mkdInlineURL = { link = 'markdownUrl' },
  mkdLink = { link = 'markdownUrl' },
  mkdLinkDef = { link = 'markdownUrl' },
  mkdListItemLine = { fg = palette.text },
  mkdRule = { fg = palette.subtle },
  mkdURL = { link = 'markdownUrl' },

  --- Treesitter Identifiers
  ['@variable'] = { fg = palette.text, italic = styles.italic },
  ['@variable.builtin'] = { fg = palette.love, bold = styles.bold },
  ['@variable.parameter'] = { fg = palette.foam, italic = styles.italic },
  ['@variable.member'] = { fg = palette.iris },

  ['@constant'] = { fg = palette.gold },
  ['@constant.builtin'] = { fg = palette.gold, bold = styles.bold },
  ['@constant.macro'] = { fg = palette.gold },

  ['@module'] = { fg = palette.text },
  ['@module.builtin'] = { fg = palette.text, bold = styles.bold },
  ['@label'] = { link = 'Label' },

  --- Literals
  ['@string'] = { link = 'String' },
  -- ["@string.documentation"] = {},
  ['@string.regexp'] = { fg = palette.iris },
  ['@string.escape'] = { fg = palette.pine },
  ['@string.special'] = { link = 'String' },
  ['@string.special.symbol'] = { link = 'Identifier' },
  ['@string.special.url'] = { fg = groups.link },
  -- ["@string.special.path"] = {},

  ['@character'] = { link = 'Character' },
  ['@character.special'] = { link = 'Character' },

  ['@boolean'] = { link = 'Boolean' },
  ['@number'] = { link = 'Number' },
  ['@number.float'] = { link = 'Number' },
  ['@float'] = { link = 'Number' },

  --- Types
  ['@type'] = { fg = palette.foam },
  ['@type.builtin'] = { fg = palette.foam, bold = styles.bold },

  -- ["@type.definition"] = {},
  -- ["@type.qualifier"] = {},

  -- ["@attribute"] = {},
  ['@property'] = { fg = palette.iris, italic = styles.italic },

  --- Functions
  ['@function'] = { fg = palette.pine },
  ['@function.builtin'] = { fg = palette.love, bold = styles.bold },
  ['@function.call'] = { fg = palette.leaf },
  ['@function.macro'] = { link = 'Function' },
  ['@function.method'] = { fg = palette.leaf },
  ['@function.method.call'] = { fg = palette.foam },

  ['@constructor'] = { fg = palette.foam },
  ['@operator'] = { link = 'Operator' },

  --- Keywords
  ['@keyword'] = { link = 'Keyword' },
  -- ["@keyword.coroutine"] = {},
  ['@keyword.function'] = { fg = palette.foam },
  ['@keyword.operator'] = { fg = palette.subtle },
  ['@keyword.import'] = { fg = palette.pine },
  ['@keyword.storage'] = { fg = palette.foam },
  ['@keyword.repeat'] = { fg = palette.pine },
  ['@keyword.return'] = { fg = palette.pine },
  ['@keyword.debug'] = { fg = palette.rose },
  ['@keyword.exception'] = { fg = palette.love },
  ['@keyword.conditional'] = { fg = palette.pine },
  ['@keyword.conditional.ternary'] = { fg = palette.pine },
  ['@keyword.directive'] = { fg = palette.iris },
  ['@keyword.directive.define'] = { fg = palette.iris },

  --- Punctuation
  ['@punctuation.delimiter'] = { fg = palette.subtle },
  ['@punctuation.bracket'] = { fg = palette.subtle },
  ['@punctuation.special'] = { fg = palette.subtle },

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
  ['@markup.strong'] = { bold = styles.bold },
  ['@markup.italic'] = { italic = styles.italic },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.underline'] = { underline = true },

  ['@markup.heading'] = { fg = palette.foam, bold = styles.bold },

  ['@markup.quote'] = { fg = palette.text },
  ['@markup.math'] = { link = 'Special' },
  ['@markup.environment'] = { link = 'Macro' },
  ['@markup.environment.name'] = { link = '@type' },

  -- ["@markup.link"] = {},
  ['@markup.link.markdown_inline'] = { fg = palette.subtle },
  ['@markup.link.label.markdown_inline'] = { fg = palette.foam },
  ['@markup.link.url'] = { fg = groups.link },

  ["@markup.raw"] = { bg = palette.surface },
  ["@markup.raw.block"] = { bg = palette.surface },
  ['@markup.raw.markdown_inline'] = { bg = palette.surface},
  ['@markup.raw.delimiter.markdown'] = { fg = palette.subtle },

  ['@markup.list'] = { fg = palette.pine },
  ['@markup.list.checked'] = { fg = palette.foam, bg = palette.foam, blend = 10 },
  ['@markup.list.unchecked'] = { fg = palette.text },

  -- Markdown headings
  ['@markup.heading.1.markdown'] = { link = 'markdownH1' },
  ['@markup.heading.2.markdown'] = { link = 'markdownH2' },
  ['@markup.heading.3.markdown'] = { link = 'markdownH3' },
  ['@markup.heading.4.markdown'] = { link = 'markdownH4' },
  ['@markup.heading.5.markdown'] = { link = 'markdownH5' },
  ['@markup.heading.6.markdown'] = { link = 'markdownH6' },
  ['@markup.heading.1.marker.markdown'] = { link = 'markdownH1Delimiter' },
  ['@markup.heading.2.marker.markdown'] = { link = 'markdownH2Delimiter' },
  ['@markup.heading.3.marker.markdown'] = { link = 'markdownH3Delimiter' },
  ['@markup.heading.4.marker.markdown'] = { link = 'markdownH4Delimiter' },
  ['@markup.heading.5.marker.markdown'] = { link = 'markdownH5Delimiter' },
  ['@markup.heading.6.marker.markdown'] = { link = 'markdownH6Delimiter' },

  ['@diff.plus'] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
  ['@diff.minus'] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
  ['@diff.delta'] = { bg = groups.git_change, blend = 20 },

  ['@tag'] = { link = 'Tag' },
  ['@tag.attribute'] = { fg = palette.iris },
  ['@tag.delimiter'] = { fg = palette.subtle },

  --- Non-highlighting captures
  -- ["@none"] = {},
  ['@conceal'] = { link = 'Conceal' },
  ['@conceal.markdown'] = { fg = palette.subtle },

  -- ["@spell"] = {},
  -- ["@nospell"] = {},

  --- LSP Semantic tokens
  ['@lsp.type.comment'] = {},
  ['@lsp.type.comment.c'] = { link = '@comment' },
  ['@lsp.type.comment.cpp'] = { link = '@comment' },
  ['@lsp.type.enum'] = { link = '@type' },
  ['@lsp.type.interface'] = { link = '@interface' },
  ['@lsp.type.keyword'] = { link = '@keyword' },
  ['@lsp.type.namespace'] = { link = '@namespace' },
  ['@lsp.type.namespace.python'] = { link = '@variable' },
  ['@lsp.type.parameter'] = { link = '@parameter' },
  ['@lsp.type.property'] = { link = '@property' },
  ['@lsp.type.variable'] = {}, -- defer to treesitter for regular variables
  ['@lsp.type.variable.svelte'] = { link = '@variable' },
  ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.typemod.operator.injected'] = { link = '@operator' },
  ['@lsp.typemod.string.injected'] = { link = '@string' },
  ['@lsp.typemod.variable.constant'] = { link = '@constant' },
  ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },
  ['@lsp.typemod.variable.injected'] = { link = '@variable' },

  --- Plugins

  -- lewis6991/gitsigns.nvim
  GitSignsAdd = { link = 'SignAdd' },
  GitSignsChange = { link = 'SignChange' },
  GitSignsDelete = { link = 'SignDelete' },
  SignAdd = { fg = groups.git_add, bg = 'NONE' },
  SignChange = { fg = groups.git_change, bg = 'NONE' },
  SignDelete = { fg = groups.git_delete, bg = 'NONE' },

  -- folke/which-key.nvim
  WhichKey = { fg = palette.iris },
  WhichKeyBorder = make_border(),
  WhichKeyDesc = { fg = palette.gold },
  WhichKeyFloat = { bg = groups.panel },
  WhichKeyGroup = { fg = palette.foam },
  WhichKeyIcon = { fg = palette.pine },
  WhichKeyIconAzure = { fg = palette.pine },
  WhichKeyIconBlue = { fg = palette.pine },
  WhichKeyIconCyan = { fg = palette.foam },
  WhichKeyIconGreen = { fg = palette.leaf },
  WhichKeyIconGrey = { fg = palette.subtle },
  WhichKeyIconOrange = { fg = palette.rose },
  WhichKeyIconPurple = { fg = palette.iris },
  WhichKeyIconRed = { fg = palette.love },
  WhichKeyIconYellow = { fg = palette.gold },
  WhichKeyNormal = { link = 'NormalFloat' },
  WhichKeySeparator = { fg = palette.subtle },
  WhichKeyTitle = { link = 'FloatTitle' },
  WhichKeyValue = { fg = palette.rose },

  -- lukas-reineke/indent-blankline.nvim
  IblIndent = { fg = palette.overlay },
  IblScope = { fg = palette.foam },
  IblWhitespace = { fg = palette.overlay },

  -- hrsh7th/nvim-cmp
  CmpItemAbbr = { fg = palette.subtle },
  CmpItemAbbrDeprecated = { fg = palette.subtle, strikethrough = true },
  CmpItemAbbrMatch = { fg = palette.text, bold = styles.bold },
  CmpItemAbbrMatchFuzzy = { fg = palette.text, bold = styles.bold },
  CmpItemKind = { fg = palette.subtle },
  CmpItemKindClass = { link = 'StorageClass' },
  CmpItemKindFunction = { link = 'Function' },
  CmpItemKindInterface = { link = 'Type' },
  CmpItemKindMethod = { link = 'PreProc' },
  CmpItemKindSnippet = { link = 'String' },
  CmpItemKindVariable = { link = 'Identifier' },

  -- NeogitOrg/neogit
  -- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
  NeogitChangeAdded = { fg = groups.git_add, bold = styles.bold, italic = styles.italic },
  NeogitChangeBothModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
  NeogitChangeCopied = { fg = groups.git_untracked, bold = styles.bold, italic = styles.italic },
  NeogitChangeDeleted = { fg = groups.git_delete, bold = styles.bold, italic = styles.italic },
  NeogitChangeModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
  NeogitChangeNewFile = { fg = groups.git_stage, bold = styles.bold, italic = styles.italic },
  NeogitChangeRenamed = { fg = groups.git_rename, bold = styles.bold, italic = styles.italic },
  NeogitChangeUpdated = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
  NeogitDiffAddHighlight = { link = 'DiffAdd' },
  NeogitDiffContextHighlight = { bg = palette.surface },
  NeogitDiffDeleteHighlight = { link = 'DiffDelete' },
  NeogitFilePath = { fg = palette.foam, italic = styles.italic },
  NeogitHunkHeader = { bg = groups.panel },
  NeogitHunkHeaderHighlight = { bg = groups.panel },

  -- ggandor/leap.nvim
  LeapLabelPrimary = { link = 'IncSearch' },
  LeapLabelSecondary = { link = 'StatusLineTerm' },
  LeapMatch = { link = 'MatchParen' },
  -- folke/flash.nvim
  FlashLabel = { fg = palette.base, bg = palette.love },

  -- nvim-telescope/telescope.nvim
  TelescopeBorder = make_border(),
  TelescopeMatching = { fg = palette.rose },
  TelescopeNormal = { link = 'NormalFloat' },
  TelescopePromptNormal = { link = 'TelescopeNormal' },
  TelescopePromptPrefix = { fg = palette.subtle },
  TelescopeSelection = { fg = palette.text, bg = palette.overlay },
  TelescopeSelectionCaret = { fg = palette.rose, bg = palette.overlay },
  TelescopeTitle = { fg = palette.foam, bold = styles.bold },



  -- rcarriga/nvim-dap-ui
  DapUIBreakpointsCurrentLine = { fg = palette.gold, bold = styles.bold },
  DapUIBreakpointsDisabledLine = { fg = palette.muted },
  DapUIBreakpointsInfo = { link = 'DapUIThread' },
  DapUIBreakpointsLine = { link = 'DapUIBreakpointsPath' },
  DapUIBreakpointsPath = { fg = palette.foam },
  DapUIDecoration = { link = 'DapUIBreakpointsPath' },
  DapUIFloatBorder = make_border(),
  DapUIFrameName = { fg = palette.text },
  DapUILineNumber = { link = 'DapUIBreakpointsPath' },
  DapUIModifiedValue = { fg = palette.foam, bold = styles.bold },
  DapUIScope = { link = 'DapUIBreakpointsPath' },
  DapUISource = { fg = palette.iris },
  DapUIStoppedThread = { link = 'DapUIBreakpointsPath' },
  DapUIThread = { fg = palette.gold },
  DapUIValue = { fg = palette.text },
  DapUIVariable = { fg = palette.text },
  DapUIWatchesEmpty = { fg = palette.love },
  DapUIWatchesError = { link = 'DapUIWatchesEmpty' },
  DapUIWatchesValue = { link = 'DapUIThread' },
  --
  -- folke/trouble.nvim
  TroubleText = { fg = palette.subtle },
  TroubleCount = { fg = palette.iris, bg = palette.surface },
  TroubleNormal = { fg = palette.text, bg = groups.panel },

  -- echasnovski/mini.nvim


  MiniIconsAzure = { fg = palette.foam },
  MiniIconsBlue = { fg = palette.pine },
  MiniIconsCyan = { fg = palette.foam },
  MiniIconsGreen = { fg = palette.leaf },
  MiniIconsGrey = { fg = palette.subtle },
  MiniIconsOrange = { fg = palette.rose },
  MiniIconsPurple = { fg = palette.iris },
  MiniIconsRed = { fg = palette.love },
  MiniIconsYellow = { fg = palette.gold },


  MiniStarterCurrent = { nocombine = true },
  MiniStarterFooter = { fg = palette.subtle },
  MiniStarterHeader = { link = 'Title' },
  MiniStarterInactive = { link = 'Comment' },
  MiniStarterItem = { link = 'Normal' },
  MiniStarterItemBullet = { link = 'Delimiter' },
  MiniStarterItemPrefix = { link = 'WarningMsg' },
  MiniStarterSection = { fg = palette.rose },
  MiniStarterQuery = { link = 'MoreMsg' },

  MiniStatuslineDevinfo = { fg = palette.subtle, bg = palette.base },
  MiniStatuslineFileinfo = { link = 'MiniStatuslineDevinfo' },
  MiniStatuslineFilename = { fg = palette.foam, bg = palette.base },
  MiniStatuslineInactive = { link = 'MiniStatuslineFilename' },
  MiniStatuslineModeCommand = { fg = palette.base, bg = palette.rose, bold = styles.bold },
  MiniStatuslineModeInsert = { fg = palette.base, bg = palette.pine, bold = styles.bold },
  MiniStatuslineModeNormal = { fg = palette.base, bg = palette.leaf, bold = styles.bold },
  MiniStatuslineModeOther = { fg = palette.base, bg = palette.rose, bold = styles.bold },
  MiniStatuslineModeReplace = { fg = palette.base, bg = palette.pine, bold = styles.bold },
  MiniStatuslineModeVisual = { fg = palette.base, bg = palette.iris, bold = styles.bold },
  MiniSurround = { link = 'IncSearch' },


  -- -- nvim-treesitter/nvim-treesitter-context
  TreesitterContext = { bg = palette.overlay },
  TreesitterContextLineNumber = { fg = palette.subtle },

  -- MeanderingProgrammer/render-markdown.nvim
  RenderMarkdownBullet = { fg = palette.rose },
  RenderMarkdownChecked = { fg = palette.foam },
  RenderMarkdownCode = { bg = palette.overlay },
  RenderMarkdownCodeInline = { fg = palette.text, bg = palette.overlay },
  RenderMarkdownDash = { fg = palette.muted },
  RenderMarkdownH1Bg = { bg = groups.h1, blend = 20 },
  RenderMarkdownH2Bg = { bg = groups.h2, blend = 20 },
  RenderMarkdownH3Bg = { bg = groups.h3, blend = 20 },
  RenderMarkdownH4Bg = { bg = groups.h4, blend = 20 },
  RenderMarkdownH5Bg = { bg = groups.h5, blend = 20 },
  RenderMarkdownH6Bg = { bg = groups.h6, blend = 20 },
  RenderMarkdownQuote = { fg = palette.subtle },
  RenderMarkdownTableFill = { link = 'Conceal' },
  RenderMarkdownTableHead = { fg = palette.subtle },
  RenderMarkdownTableRow = { fg = palette.subtle },
  RenderMarkdownUnchecked = { fg = palette.subtle },


  rmdCodeDelim = {fg = palette.rose},
  --ufo
  -- UfoFoldedBg = { fg = palette.foam, bg = palette.rose } ,
  -- UfoFoldedFg = { fg = palette.love , bg = palette.foam },
  --  UfoPreviewSbar = { fg = palette.foam, bg = palette.pine},
  --  UfoPreviewThumb = { fg = palette.foam, bg = palette.pine},
  --  UfoPreviewWinBar= { fg = palette.foam, bg = palette.pine},
  --  UfoPreviewCursorLine= { fg = palette.foam, bg = palette.pine},
  --  UfoFoldedEllipsis= { fg = palette.love , bg = palette.foam },
  --  UfoCursorFoldedLine= { fg = palette.foam, bg = palette.pine},
  -- BufferInactiveSign={ fg = palette.foam, bg = palette.pine},
  --     BufferVisibleSign={ fg = palette.foam, bg = palette.iris},
}
local transparency_highlights = {
  CursorLine = { bg = palette.muted, },

  DiagnosticVirtualTextError = { fg = groups.error },
  DiagnosticVirtualTextHint = { fg = groups.hint },
  DiagnosticVirtualTextInfo = { fg = groups.info },
  DiagnosticVirtualTextOk = { fg = groups.ok },
  DiagnosticVirtualTextWarn = { fg = groups.warn },

  FloatBorder = { fg = groups.border, bg = 'NONE' },
  FloatTitle = { fg = groups.border, bg = 'NONE', bold = styles.bold },
  Folded = { fg = palette.text, bg = 'NONE' },
  NormalFloat = { bg = 'NONE' },
  Normal = { fg = palette.text, bg = 'NONE' },
  NormalNC = { fg = palette.text, bg = config.dim_inactive_windows and palette._nc or 'NONE' },
  Pmenu = { fg = palette.gold, bg = 'NONE' },
  PmenuKind = { fg = palette.foam, bg = 'NONE' },
  SignColumn = { fg = palette.text, bg = 'NONE' },
  StatusLine = { fg = palette.subtle, bg = 'NONE' },
  StatusLineNC = { fg = palette.muted, bg = 'NONE' },
  TabLine = { bg = 'NONE', fg = palette.subtle },
  TabLineFill = { bg = 'NONE' },
  TabLineSel = { fg = palette.text, bg = 'NONE', bold = styles.bold },

  -- ['@markup.raw'] = { bg = "NONE" },
  -- ['@markup.raw.block'] = { fg = palette.rose, bg = "NONE" },
  -- ['@markup.raw.markdown_inline'] = {bg = 'NONE'},
  -- ['@markup.raw.delimiter.markdown'] = {bg = 'NONE'},
  RenderMarkdownCode = {bg = 'NONE'},
  RenderMarkdownCodeInline = {bg = 'NONE'},
  rmdCodeDelim = {fg = palette.rose, bg = 'NONE'},

  mkdCode = {bg = 'NONE'},
  mkdCodeDelimiter = {bg = 'NONE'},
  mkdCodeEnd = {bg = 'NONE'},
  mkdCodeStart = {bg = 'NONE'},


  TelescopeNormal = { fg = palette.subtle, bg = 'NONE' },
  TelescopePromptNormal = { fg = palette.text, bg = 'NONE' },
  TelescopeSelection = { fg = palette.text, bg = 'NONE', bold = styles.bold },
  TelescopeSelectionCaret = { fg = palette.rose },

  WhichKeyFloat = { bg = 'NONE' },
  WhichKeyNormal = { bg = 'NONE' },

  IblIndent = { fg = palette.muted },
  IblScope = { fg = palette.subtle },
  IblWhitespace = { fg = palette.rose },

  TreesitterContext = { fg = palette.subtle, bg = 'NONE' },
  TreesitterContextLineNumber = { fg = palette.subtle, bg = 'NONE' },

  MiniFilesTitleFocused = { fg = palette.rose, bg = 'NONE', bold = styles.bold },

  MiniPickPrompt = { bg = 'NONE', bold = styles.bold },
  MiniPickBorderText = { bg = 'NONE' },
}

for group, highlight in pairs(default_highlights) do
  highlights[group] = highlight
end

if styles.transparency then
  for group, highlight in pairs(transparency_highlights) do
    highlights[group] = highlight
  end
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
  if config.before_highlight ~= nil then
    config.before_highlight(group, highlight, palette)
  end
  if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
    highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
  end
  vim.api.nvim_set_hl(0, group, highlight)
end

--- Terminal
if config.enable.terminal then
  vim.g.terminal_color_0 = palette.overlay -- black
  vim.g.terminal_color_8 = palette.subtle -- bright black
  vim.g.terminal_color_1 = palette.love -- red
  vim.g.terminal_color_9 = palette.love -- bright red
  vim.g.terminal_color_2 = palette.pine -- green
  vim.g.terminal_color_10 = palette.pine -- bright green
  vim.g.terminal_color_3 = palette.gold -- yellow
  vim.g.terminal_color_11 = palette.gold -- bright yellow
  vim.g.terminal_color_4 = palette.foam -- blue
  vim.g.terminal_color_12 = palette.foam -- bright blue
  vim.g.terminal_color_5 = palette.iris -- magenta
  vim.g.terminal_color_13 = palette.iris -- bright magenta
  vim.g.terminal_color_6 = palette.rose -- cyan
  vim.g.terminal_color_14 = palette.rose -- bright cyan
  vim.g.terminal_color_7 = palette.text -- white
  vim.g.terminal_color_15 = palette.text -- bright white

  -- Support StatusLineTerm & StatusLineTermNC from vim
  vim.cmd([[
  augroup rose-pine
  autocmd!
  autocmd TermOpen * if &buftype=='terminal'
  \|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
  \|else|setlocal winhighlight=|endif
  autocmd ColorSchemePre * autocmd! rose-pine
  augroup END
  ]])
end
