---@type string[]
local library = {}

-- TODO 动态加载
local path_config = vim.fn.expand(vim.fn.stdpath("config"))
local path_startup_cwd = vim.fn.expand(vim.fn.getcwd())
if vim.fs.relpath(path_config, path_startup_cwd) ~= nil then
    vim.notify("Set lua-language-server for neovim configuration.")
    table.insert(library, vim.fn.expand("$VIMRUNTIME/lua"))
    table.insert(library, vim.fn.expand("${3rd}/luv/library"))

    local runtimepaths = vim.split(vim.api.nvim_get_option_value("runtimepath", {}), ",")
    local lazypath = vim.fn.expand(vim.fn.stdpath("data") .. "/lazy")
    for _, path in ipairs(runtimepaths) do
        local _path = vim.fn.expand(path)
        if vim.fs.relpath(lazypath, _path) ~= nil then
            -- TODO 不添加所有插件
            table.insert(library, _path)
        end
    end
end

---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    -- FIXME lua_ls 双重加载
    -- root_markers = {
    --     "luarc.json",
    --     "luarc.jsonc",
    --     ".git",
    -- },
    -- before_init = function(client)
    --     table.insert(library, vim.fn.expand("$VIMRUNTIME/lua"))
    --     table.insert(library, vim.fn.expand("${3rd}/luv/library"))
    -- end,
    settings = {
        Lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
            workspace = {
                checkThirdParty = false,
                library = library,
            }
            -- runtime = {
            --     version = "LuaJIT",
            -- },
            -- workspace = {
            --     checkThirdParty = false,
            --     library = library,
            -- },
            -- telemetry = {
            --     enable = false,
            -- },
        },
    }
}
