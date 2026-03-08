
local function configure_shell()
    local sysname = vim.uv.os_uname().sysname
    if sysname == "Windows_NT" then
        local env_shell = os.getenv("SHELL")
        -- Windows Git Bash
        if env_shell and env_shell:find("bash") then
            vim.opt.shellcmdflag = "-c"
            vim.opt.shellquote = ""
            vim.opt.shellxquote = ""
        end
    end
end
configure_shell()

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
        -- -- https://github.com/smoka7/multicursors.nvim
        -- {
        --     "smoka7/multicursors.nvim",
        --     event = "VeryLazy",
        --     dependencies = {
        --         'nvimtools/hydra.nvim',
        --     },
        --     opts = {},
        --     cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
        --     keys = {
        --         {
        --             mode = { 'v', 'n' },
        --             '<Leader>m',
        --             '<cmd>MCstart<cr>',
        --             desc = 'Create a selection for selected text or word under the cursor',
        --         },
        --     },
        -- },
        -- https://github.com/nvim-treesitter/nvim-treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            lazy = false,
            build = ":TSUpdate",
            opts = {
                highlight = { enable = true, },
                ident     = { enable = true, },
                folding   = { enable = true, },
            },
            init = function()
                -- `zi` 切换折叠使能
                -- `za` 切换当前折叠
                -- `zM` 关闭所有折叠
                -- `zR` 打开所有折叠
                vim.opt.foldenable = true
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.opt.foldlevel = 99
                vim.opt.foldcolumn = "1"
                -- vim.opt.fillchars = {
                --     fold = " ",
                --     foldopen = "",
                --     foldclose = "",
                --     foldsep = " ",
                -- }
            end
        },
        ---------------------------------------------------------------------------------------
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins.lua`
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins/init.lua`
        -- `$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua`
        { import = "plugins" },
    },
}
require("lazy").setup(lazy_config)

if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h12"
    -- Transparency (>= 0.14.0)
    -- vim.g.neovide_opacity = 0.95
    -- vim.g.neovide_normal_opacity = 0.95
    -- Titile Bar Color (>= 0.14.0 && Windows-Only)
    vim.g.neovide_title_background_color = string.format(
        "%x",
        vim.api.nvim_get_hl(0, {id=vim.api.nvim_get_hl_id_by_name("Normal")}).bg
    )
end
