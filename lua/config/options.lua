--
-- use `:help <option>` to figure out the meaning of `<option>`
--
--

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.mouse = "nvi"
vim.opt.termguicolors = true

vim.opt.autoread = true

vim.opt.clipboard = "unnamedplus"

-- Tab
vim.opt.expandtab = true -- Use <space>s instead of <tab>
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- UI Config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.showmode = true
vim.opt.scrolloff = 8
