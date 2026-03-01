
local library = {
    vim.fn.expand("$VIMRUNTIME/lua"),
    "${3rd}/luv/library",
}

-- TODO 将插件加入到 lua-language-server 识别路径
-- C:\Users\no-ve\.config\nvim,C:\Users\no-ve\AppData\Local\nvim-data\site,C:\Users\no-ve\AppData\Local\nvim-data\lazy\lazy.nvim,C:/Users/no-ve/AppData/Local/nvim-data/lazy/nvim-autopairs,C:\Users\no-ve\AppData\Local\nvim-data\lazy\indent-blankline.nvim,C:\Users\no-ve\AppData\Local\nvim-data\lazy\blink.cmp,C:\Users\no-ve\AppData\Local\nvim-data\lazy\nvim-treesitter,C:\Users\no-ve\AppData\Local\nvim-data\lazy\bufferline.nvim,C:\Users\no-ve\AppData\Local\nvim-data\lazy\nvim-web-devicons,C:\Users\no-ve\AppData\Local\nvim-data\lazy\lualine.nvim,C:\Users\no-ve\AppData\Local\nvim-data\lazy\snacks.nvim,C:\Users\no-ve\AppData\Local\nvim-data\lazy\onedark.nvim,C:\Users\no-ve\scoop\apps\neovim\current\share\nvim\runtime,C:\Users\no-ve\scoop\apps\neovim\current\share\nvim\runtime\pack\dist\opt\netrw,C:\Users\no-ve\scoop\apps\neovim\current\share\nvim\runtime\pack\dist\opt\matchit,C:\Users\no-ve\scoop\apps\neovim\current\lib\nvim,C:\Users\no-ve\AppData\Local\nvim-data\lazy\readme,C:\Users\no-ve\AppData\Local\nvim-data\lazy\indent-blankline.nvim\after 
-- local runtimepath = vim.split(vim.api.nvim_get_option_value("runtimepath", {}), ",")
-- local lazypath = vim.fn.stdpath("data") .. "lazy"
-- for _, path in ipairs(runtimepath) do
-- end

---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = library,
            },
            telemetry = {
                enable = false,
            },
        },
    }
}
