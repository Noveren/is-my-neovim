
local library = {
    vim.fn.expand("$VIMRUNTIME/lua"),
    vim.fn.expand("${3rd}/luv/library"),
}

local runtimepath = vim.split(vim.api.nvim_get_option_value("runtimepath", {}), ",")
local lazypath = vim.fn.expand(vim.fn.stdpath("data") .. "/lazy")
for _, path in ipairs(runtimepath) do
    local _path = vim.fn.expand(path)
    if vim.fs.relpath(lazypath, _path) ~= nil then
        table.insert(library, _path)
    end
end

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
