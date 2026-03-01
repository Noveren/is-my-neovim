local github_mirror = "https://gh-proxy.org/"
local plugin_enabled = true

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


vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("zls")
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,  { buffer = event.buf, desc = "LSP: Goto definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP: Goto declaration" })
        vim.diagnostic.config({
            virtual_text = true,
        })
    end
})


---@type LazySpec
local plugin_onedark = {
    "navarasu/onedark.nvim",
    enabled = plugin_enabled and true,
    -- https://github.com/navarasu/onedark.nvim
    opts = {},
    init = function() require("onedark").load() end
}

---@type LazySpec
local plugin_nvim_autopairs = {
    "windwp/nvim-autopairs",
    -- https://github.com/windwp/nvim-autopairs
    enabled = plugin_enabled and true,
    event = "InsertEnter",
    opts = {},
}

---@type LazySpec
local plugin_ident_blankline = {
    "lukas-reineke/indent-blankline.nvim",
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    enabled = plugin_enabled and true,
    event = "VeryLazy",
    main = "ibl",
    opts = {},
}

---@type LazySpec
local plugin_treesitter = {
    "nvim-treesitter/nvim-treesitter",
    -- https://github.com/nvim-treesitter/nvim-treesitter
    enabled = plugin_enabled and true,
    lazy = false,
    build = ":TSUpdate",
}

---@type LazySpec
local plugin_snacks = {
    "folke/snacks.nvim",
    -- https://github.com/folke/snacks.nvim
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
        ---@type snacks.picker.Config
        picker = {
        },
        ---@type snacks.picker.explorer.Config
        explorer = {
            enabled = true,
            exclude = {},
        },
        ---@type snacks.statuscolumn.Config
        statuscolumn = {
            enabled = true,
            left = { "mark", "git", "fold" },
            right = { "sign" },
            folds = {
                open = true,
                git_hl = true,
            }
        },
        ---@type snacks.terminal.Config
        terminal = {
            enabled = true,
        },
    },
    keys = {
        { "<C-e>", function() Snacks.explorer.open() end, desc = "Toggle Explorer" },
        {
            "<C-p>",
            function()
                Snacks.picker.smart({
                    multi = { "files", "buffers" }, format = "file",
                })
            end,
            desc = "Smart Files"
        },
        -- { "<C-t", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
        -- { "<C-S-p>", function() Snacks.picker.commands() end, desc = "Commands" },
    }
}

---@type LazySpec
local plugin_lualine = {
    'nvim-lualine/lualine.nvim',
    -- https://github.com/nvim-lualine/lualine.nvim
    enabled = plugin_enabled and true,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", },
    opts = {
        options = {
            icons_enabled = true,
            theme = "onedark",
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
    },
}

---@type LazySpec
local plugin_bufferline = {
    "akinsho/bufferline.nvim",
    -- https://github.com/akinsho/bufferline.nvim
    enabled = plugin_enabled and true,
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            offsets = { {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            } },
            separator_style = "slant",
            numbers = function(opts)
                return string.format('%s', opts.raise(opts.id))
            end,
        }
    },
}

-- -@type LazySpec
local plugin_blink = {
    "saghen/blink.cmp",
    -- https://github.com/Saghen/blink.cmp
    enabled = plugin_enabled and true,
    -- optional: provides snippets for the snippet source
    -- dependencies = {
    --     "rafamadriz/friendly-snippets",
    -- },
    version = "1.*",
    event = "VeryLazy",

    -- https://cmp.saghen.dev/
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
            },
        },
        fuzzy = {
            implementation = "lua",
            -- implementation = "rust",
            -- proxy = {
            --     from_env = false,
            --     url = github_mirror,
            -- },
        },
        sources = {
            -- lsp, path, snippets, buffer
            default = { 'lsp', 'path', 'buffer' },
        },
        keymap = {
            preset = "super-tab",
        },
        cmdline = {
            sources = function()
                local cmd_type = vim.fn.getcmdtype()
                if cmd_type == "/" or cmd_type == "?" then
                    return { "buffer" }
                end
                if cmd_type == ":" then
                    return { "cmdline" }
                end
                return {}
            end,
            keymap = {
                preset = "super-tab",
            },
            completion = {
                menu = {
                    auto_show = true,
                },
            },
        },
    }
}
---@type LazyConfig
local lazy_config = {
    spec = {
        plugin_onedark,
        plugin_nvim_autopairs,
        plugin_ident_blankline,
        plugin_treesitter,
        plugin_blink,
        plugin_lualine,
        plugin_bufferline,
        plugin_snacks,
    },
    install = {
        missing = false,
    },
    git = {
        url_format = github_mirror .. "https://github.com/%s.git",

    },
}
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
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"
end
lazy_install()
-- require("lazy").setup({{ import = "plugins" }})
-- require("lazy").setup("plugins")
--  `$XDG_CONFIG_HOME/nvim/lua/plugins.lua`
--  `$XDG_CONFIG_HOME/nvim/lua/plugins/init.lua`
--  `$XDG_CONFIG_HOME/nvim/lua/plugins/*.lua`
require("lazy").setup(lazy_config)
