
require("config.options")
require("config.keymaps")
require("config.lsp")

vim.filetype.add({
    extension = {
    },
    filename = {
        -- [".clangd"] = "yaml",
    },
})

local github_mirror = "https://gh-proxy.org/"
local function lazy_install()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        local url = github_mirror .. "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({
            "git", "clone", "--filter=blob:none", "--branch=stable",
            url, lazypath,
        })
        if vim.v.shell_error ~= 0 then
            error("Failed to clone lazy.nvim:\n" .. out)
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.runtimepath:prepend(lazypath)
end
lazy_install()
---@type LazyConfig
local lazy_config = {
    git = { url_format = github_mirror .. "https://github.com/%s.git" },
    install = { missing = false, colorscheme = { "onedark" } },
    spec = {
        -- https://github.com/navarasu/onedark.nvim
        {
            "navarasu/onedark.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
            init = function() require("onedark").load() end
        },
        -- https://github.com/windwp/nvim-autopairs
        { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
        -- https://github.com/lukas-reineke/indent-blankline.nvim
        { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
        -- https://github.com/nvim-treesitter/nvim-treesitter
        { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
        ---------------------------------------------------------------------------------------
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins.lua`
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins/init.lua`
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua`
        { import = "plugins" },
    },
}
require("lazy").setup(lazy_config)
