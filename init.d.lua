---@meta
--- Neovim
--- https://github.com/luals/lua-language-server

---@class vim
---@field o any Vim options can be accessed through vim.opt, which behaves like vimscript :set.
---@field opt Option
---@field g G
---@field api API
vim = {}

---@class G
local G = {}
---A special interface exists for conveniently interacting with list- and
---map-style options from Lua: It allows accessing them as Lua tables and
---offers object-oriented method for adding and removing entries.
---https://neovim.io/doc/user/lua/#vim.opt
---@class Option
---@field mouse string (default 'nvi') 使能鼠标可用模式，由 `n v i` 组合
---@field scrolloff number (default 0) 保持光标上下的最小屏幕线数
-- local Option = {}

---@class API
local API = {}

---Sets a global mapping for the given mode.
---Unlike :map, leading/trailing whitespace is accepted as part of the
---{lhs} or {rhs}. Empty {rhs} is <Nop>. |keycodes| are replaced as usual.
---@param mode string https://neovim.io/doc/user/map/#map-table
---|"''"   # Norm Vis Sel Opr Term
---|"'n'"  # Norm
---|"'!'"  # Ins Cmd
---|"'i'"  # Ins
---|"'v'"  # Vis Sel
---|"'x'"  # Vis
---|"'s'"  # Sel
---|"'o'"  # Opr
---|"'t'"  # Term
---|"'l'"  # Ins Cmd Lang
---@param lhs string Left-hand-side of the mapping.
---@param rhs string Right-hand-side of the mapping.
---@param opts? Keymap Values are booleans (default false)
function API.nvim_set_keymap(mode, lhs, rhs, opts) end

---@class Keymap vim.api.keyset.keymap
---@field noremap boolean disable recursive mapping
---@field silent boolean disable being echoed on the command line.

-- ---@enum keys
-- local KEYS = {
-- }
