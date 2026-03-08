vim.lsp.enable "lua_ls"           -- lua
vim.lsp.enable "clangd"           -- c/c++
vim.lsp.enable "zls"              -- zig
vim.lsp.enable "rust_analyzer"    -- rust
vim.lsp.enable "tombi"            -- toml
vim.lsp.enable "ty"               -- python
-- TODO tinymist
-- TODO just-lsp https://github.com/terror/just-lsp
-- TODO asm-lsp https://github.com/bergercookie/asm-lsp
-- TODO https://github.com/typescript-language-server/typescript-language-server

-- TODO :Lsp [<language>]
-- ---@type table<string, string|nil>
-- local language_server = {
--     lua = "lua_ls",
-- }
-- vim.api.nvim_create_user_command("Lsp", function(args)
--     vim.notify(args.args)
-- end, {
--     nargs = "?",
--     desc = "Enable/Disable language server.",
--     force = true,
-- })

-- TODO checkhealth

local function lsp_attach(_)
    vim.diagnostic.config({
        virtual_text = {
            source = false,
            limit = 20,
            spacing = 2,
        },
        signs = true,
        underline = true,
    })
    vim.keymap.set("n", "E", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
end
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = lsp_attach,
})


