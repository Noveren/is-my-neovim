
local function options()
  -- 系统
  vim.opt.termguicolors = true
  vim.opt.mouse = "nvi"
  vim.opt.showmode = false
  vim.opt.autoread = true  -- 文件内容自动重载
  vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

  -- 左侧
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.scrolloff = 8
  vim.opt.cursorline = true
  vim.opt.signcolumn = "yes:1"

  -- 缩进
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true

  -- 分屏
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- vim.opt.winborder = "bold"

  -- Shell
  local sysname = vim.uv.os_uname().sysname
  if sysname == "Windows_NT" then
    -- vim.opt.shellslash = true
    local env_shell = os.getenv("SHELL")
    -- Windows Git Bash
    if env_shell and env_shell:find("bash") then
      vim.opt.shellcmdflag = "-c"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
    end
  end
end options()

-- n: % 匹配括号跳转
-- n: gh, gd, <C-k> <C-i> LSP 跳转
-- n: gra LSP Code Action
-- n: f <char> 当前行字符跳转
-- n /<word> ?<word> 全文搜索跳转（前后）使用 n 切换
-- :<range>s/<pattern>/<template>/g
  -- 使用 `:verbose map [<key>]` 查看按键映射
local function keymaps()

  -- <leader>
  vim.opt.timeoutlen = 500
  -- vim.opt.ttimeoutlen = 500
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })

  -- 窗口焦点切换
  vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

  -- 窗口大小调整
  vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<CR>")
  vim.keymap.set("n", "<C-Down>",  "<cmd>resize -3<CR>")
  -- TODO 区分垂直分割线位置
  vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<CR>")
  vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")
  -- 单行上下移动
  vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>", { desc = "Move line Up."   })
  vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>", { desc = "Move line down." })

  vim.keymap.set("n", "<CR>", "i<CR><Esc>")           -- 空白插入
  vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- 取消高亮

  -- TODO
  -- vim.keymap.set("t", "<Esc><Esc>", function()
  -- end, { noremap = true })
  --   vim.cmd("stopinsert")
  --

  ---@type integer | nil
  vim.g.my_switch_terminal_last_buf = nil

  vim.keymap.set("n", "<C-t>", function()
    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_win = vim.api.nvim_get_current_win()
    local cur_buftype = vim.api.nvim_get_option_value("buftype", { buf = cur_buf })
    if cur_buftype == "" then
      local terminal_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local flag = vim.api.nvim_buf_is_valid(buf)
        flag = flag and vim.api.nvim_buf_is_loaded(buf)
        flag = flag and vim.api.nvim_get_option_value("buftype", { buf = buf }) == "terminal"
        if flag then
            terminal_buf = buf
            break
        end
      end
      vim.g.my_switch_terminal_last_buf = cur_buf
      if terminal_buf ~= nil then
        vim.api.nvim_win_set_buf(cur_win, terminal_buf)
      else
        vim.cmd[[terminal]]
      end
      return
    end
    if cur_buftype == "terminal" then
      if vim.g.my_switch_terminal_last_buf ~= nil then
        local flag = vim.api.nvim_buf_is_valid(vim.g.my_switch_terminal_last_buf)
        if flag then
          vim.api.nvim_win_set_buf(cur_win, vim.g.my_switch_terminal_last_buf)
        end
      end
      return
    end
  end, { desc = "Terminal" })
end keymaps()
