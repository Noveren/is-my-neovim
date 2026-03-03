vim.lsp.enable "lua_ls" -- lua
vim.lsp.enable "clangd" -- c/c++
vim.lsp.enable "zls"    -- zig
vim.lsp.enable "tombi"  -- toml
vim.lsp.enable "ty"     -- python
-- TODO just-lsp https://github.com/terror/just-lsp
-- TODO asm-lsp https://github.com/bergercookie/asm-lsp
-- TODO https://github.com/typescript-language-server/typescript-language-server

---@param event vim.api.keyset.create_autocmd.callback_args
local function lsp_attach(event)
    vim.diagnostic.config({
        virtual_text = true,
    })
end
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = lsp_attach,
})
