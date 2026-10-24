-- ssh 终端剪贴板互通
vim.g.clipboard = "osc52"

require("general")
require("plugin")
require("lsp")
if vim.g.neovide then
  require("neovide")
end
