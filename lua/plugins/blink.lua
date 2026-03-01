-- https://github.com/Saghen/blink.cmp
return {
    "saghen/blink.cmp",
    version = "1.*",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            menu = {
                auto_show = true,
            },
            documentation = {
                auto_show = true,
            },
            -- ghost_text = {
            --     enabled = true,
            --     show_with_menu = true,
            -- },
        },
        fuzzy = {
            implementation = "lua",
            -- implementation = "rust",
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
