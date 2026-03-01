---@type vim.lsp.Config
return {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "h" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        ".git",
    },
}
