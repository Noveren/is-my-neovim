
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- 自动重载
vim.opt.autoread = true

-- 鼠标操作
vim.opt.mouse = "nvi"

-- 剪贴同步；使用 `vim.schedule` 延后调用以加快启动速度
vim.schedule(function() vim.opt.clipboard = "unnamedplus" end)

-- 24-bit 真彩
vim.opt.termguicolors = true

-- 左侧行数
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.cursorline = true
-- 列宽标识
vim.opt.colorcolumn = "80"
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("terminal-open", { clear = true }),
    pattern = "*",
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.foldenable = false
        vim.opt_local.cursorline = false
        vim.opt_local.colorcolumn = ""
    end
})

-- 缩进制表
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Use <space>s instead of <tab>

-- 分屏位置
vim.opt.splitright = true
vim.opt.splitbelow = true

