--- `"<cmd>"` == `":", { silent=true }`

vim.o.timeoutlen = 500
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 调整 Ctrl-v Visual-block
vim.keymap.set("n", "<A-v>", "<C-v>", { remap = false })

-- 使用 `ESC` 清除搜索高亮
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- 窗口焦点切换
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- 窗口大小调整
vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-Down>",  "<cmd>resize -3<CR>")
vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- 单行上下移动
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>", { desc = "Move line Up."   })
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>", { desc = "Move line down." })

-- 使用 `<CR>` 插入空白行
vim.keymap.set("n", "<CR>", "i<CR><Esc>")
