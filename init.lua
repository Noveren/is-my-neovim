vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
-- vim.opt.colorcolumn = "80"
-- Tab & Shift
vim.opt.expandtab = true -- Use <space>s instead of <tab>
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
vim.opt.autoread = true
vim.opt.mouse = "nvi"
-- 同步 OS 和 Neovim 剪贴板；使用 `vim.schedule` 延后调用以加快启动速度
-- 使用 `nvim --startuptime startuptime.log` 获得启动时间事件日志
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- 使用 `ESC` 清除搜索高亮
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- 映射窗口焦点切换
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "move focus to the left." })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "move focus to the right." })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "move focus to the bottom." })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "move focus to the top." })

--使用 `<CR>` 插入空白行
vim.api.nvim_set_keymap("n", "<CR>", "i<CR><Esc>", { noremap = true, silent = true })

-- TODO nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--TODO Lazy
--TODO vim.lsp
require("config.lazy")

-- if vim.g.vscode == nil then
-- end
