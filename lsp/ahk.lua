local getInterpreterPath = function()
  if IsWindows() then
    return vim.fn.expand("C://Program Files/AutoHotkey/v2/AutoHotkey64.exe")
  else
    return vim.fn.expand("$WINHOME/../../Program Files/AutoHotkey/v2/AutoHotkey64.exe")
  end
end
local interpreterPath = getInterpreterPath()

local getLspPath = function()
  if IsWindows() then
    return vim.fn.expand("$HOME/git/vscode-autohotkey2-lsp/server/dist/server.js")
  else
    return vim.fn.expand("$WINHOME/git/vscode-autohotkey2-lsp/server/dist/server.js")
  end
end
local lspPath = getLspPath()

return {
  cmd = {
    "node",
    vim.fn.expand(lspPath),
    "--stdio"
  },
  filetypes = { "ahk", "autohotkey", "ah2" },
  init_options = {
    locale = "en-us",
    InterpreterPath = interpreterPath,
  },
}
