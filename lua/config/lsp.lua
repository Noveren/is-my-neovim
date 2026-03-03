vim.lsp.enable "lua_ls"
vim.lsp.enable "clangd"
vim.lsp.enable "zls"
vim.lsp.enable "tombi"

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
