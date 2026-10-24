if vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.getreg('"', 1, 1), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = "OSC52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*"), },
    paste = { ["+"] = paste, ["*"] = paste, },
  }
end

require("general")
require("plugin")
require("lsp")
if vim.g.neovide then
  require("neovide")
end
