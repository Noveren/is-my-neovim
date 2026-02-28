---@meta
--- Neovim
--- https://github.com/luals/lua-language-server

---@class vim
---@field o any Vim options can be accessed through vim.opt, which behaves like vimscript :set.
---@field opt Option
---@field g G Global (g:) editor variables.
---@field keymap Keymap
---@field api API
---@field fn Fn
---@field lsp LSP
---@field fs FileSystem
---@field uv UV Exposes the "luv" lua bindings for the libuv library that nvim uses for networking, filesystem and process managment.
---@field loop Loop Use `vim.uv` instead.
---@field v V
vim = {}

---@param fn fun() 由 main-event-loop 延后调用
function vim.schedule(fn) end

---@param msg string
---@param level? integer
---@param opts? NotifyOptions
function vim.notify(msg, level, opts) end

---@class NotifyOptions

---A special interface exists for conveniently interacting with list- and
---map-style options from Lua: It allows accessing them as Lua tables and
---offers object-oriented method for adding and removing entries.
---https://neovim.io/doc/user/lua/#vim.opt
---使用 `:help vim.opt` 或 `:help option-list` 查看配置项
---@class Option
---@field number boolean (default false) 显示行号
---@field relativenumber boolean (default false) 启用相对行号
---@field mouse string (default 'nvi') 使能鼠标可用模式，由 `n v i` 组合
---@field showmode boolean (default true) 在 Ins, Rep, Vis 模式下，将信息写在最后一行
---@field clipboard string
---|'""'             # 不同步
---|'"unnamed"'      # Yank, delete, change, put 都使用 `*` 寄存器
---|'"unnamedplus"'  # Yank, delete, change, put 都使用 `+` 寄存器 (现代操作系统)
---@field scrolloff number (default 0) 保持光标上下的最小屏幕线数
---@field cursorline boolean (default false) 高亮当前行
---@field colorcolumn string (default "") 高亮指定列；`"<line_number>[,...]"`
---@field termguicolors boolean (default false) 启用 24-bit RGB 颜色
---@field autoread boolean (default true) 文件内容改变时自动重载
---@field expandtab boolean (default false) 插入模式输入时，自动将 `<Tab>` 转换为若干 `<Space>`
---@field tabstop integer (default 8) `<Tab>` 渲染时对应的 `<Space>` 数量
---@field softtabstop integer (default 0)
---@field shiftwidth integer (defualt 8) 缩进对应的 `<Space>` 数量
---@field runtimepath RuntimePath
-- local Option = {}

---@class RuntimePath
local RuntimePath = {}

---@param path string
function RuntimePath:prepend(path) end

---@class G
---@field mapleader string `<Leader>`；修改后，不影响已定义的按键
---@field maplocalleader string `<LocalLeader>`；修改后，不影响已定义的按键
---@field [string] any
local G = {}

---@class Keymap
local Keyamp = {}

---@param modes string|string[]
---@param lhs string
---@param opts? KeymapDelOptions
function Keyamp.del(modes, lhs, opts) end

---@class KeymapDelOptions
---@field buffer? integer|boolean 指定移除映射的缓冲区，`0` 或 `true` 表示当前缓冲区

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? KeymapSetOptions
function Keyamp.set(mode, lhs, rhs, opts) end

---@class KeymapSetOptions: KeymapOptions
---@field replace_keycodes? boolean (default: true)
---@field buffer? integer|boolean
---@field remap? boolean (default false)

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
---@param opts? KeymapOptions Values are booleans (default false)
function API.nvim_set_keymap(mode, lhs, rhs, opts) end

-- function API.nvim_echo

---@class KeymapOptions vim.api.keyset.keymap
---@field noremap? boolean disable recursive mapping
---@field silent? boolean disable being echoed on the command line.
---@field desc? string human-readable description.

-- ---@enum keys
-- local KEYS = {
-- }

---@param event AutocmdEvent|AutocmdEvent[]
---@param opts AutocmdOptions
---@return number autocmd_id
function API.nvim_create_autocmd(event, opts) end

---@class AutocmdOptions
---@field group? string|integer autocommand group name or id to match against.
---@field pattern? string|string[] pattern(s) to match literally autocmd-pattern
---@field buffer? integer
---@field desc? string
---@field callback? fun(args: AutocmdCallbackArguments): boolean|nil lua function or vimscript function name, lua callback can return a truthy value to delete the auto autocommand, and recevices one argument (a table with these keys)
---@field command? string vim command to execute on envent. cannot be used with callback.
---@field once? boolean (false) run the autocommand only once.
---@field nested? boolean (false) Run nested autocommands autocmd-nested.

---@class AutocmdCallbackArguments
---@field id number
---@field event string
---@field group number|nil
---@field file string
---@field match string
---@field buf number
---@field data any

---@alias AutocmdEvent
---| "'FileType'"

---@class Fn
local Fn = {}

---@return string
---|"'/'"
---|"'?'"
---|"':'"
function Fn.getcmdtype() end

-- FIXME
---@param cmd string[]
---@return string
function Fn.system(cmd) end

---@param expr? integer
---@param opts? any
function Fn.getchar(expr, opts) end

---
---@param p string
---|"'config'" Returns the user configuration directory.
---|"'data'" Returns the user data directory.
---|"'cache'" Returns the cache directory.
---@return string
function Fn.stdpath(p) end

---@class LSP
local LSP = {}

---@param config LSPClientConfig
---@param opts? LSPStartOptions
function LSP.start(config, opts) end

---@class LSPClientConfig
---@field name? string
---@field cmd string[]|fun(dispatchers: any): any 启动语言服务器的命令字符串数组 (与 jobstart() 处理方式相同, 可执行程序必须为绝对路径或位于 $PATH, shell 构造如 "~" 将不会展开).
---@field root_dir? string LSP 将根据其在初始化时确定 workspaceFolders、rootUri 和 rootPath 的目录
---@field before_init? fun(params: any, config: LSPClientConfig)

---@class LSPStartOptions
---@field reuse_client fun(client: any, config: LSPClientConfig): boolean
---@field bufnr integer
---@field silent boolean

---更新指定 LSP 客户端的配置
---@param name string LSP 名称；使用 "*" 表示设置所有客户端默认设置
---@param cfg LSPConfig
function LSP.config(name, cfg) end

---@class LSPConfig: LSPClientConfig
---@field cmd? string[]
---@field filetypes? string[] 当 LSP 使能后将会分析的文件类型，默认为所有文件类型
---@field reuse_client? fun(client: any, config: LSPClientConfig): boolean
---@field root_dir? string|fun(bufnr: integer, on_dir:fun(root_dir?: string))
---@field root_markders? (string|string[])[] 当未提供 root_dir 时，用于检测工作区根目录的标志文件

---@class FileSystem
local FileSystem = {}

---@param source integer|string 缓冲区 ID
---@param marker string|string[]|fun(name: string, path: string): boolean[]
function FileSystem.root(source, marker) end

---@class UV
local UV = {}

---@param path string
---@return FileStat|nil
function UV.fs_stat(path) end

---@class FileStat
---@field dev integer

---@class Loop

---@class V
---@field shell_error integer Result of the last shell command. When non-zero, the last shell command had an error.
