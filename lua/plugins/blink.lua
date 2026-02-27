return {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    -- dependencies = {
    --     "rafamadriz/friendly-snippets",
    -- },
    version = "1.*",
    event = "VeryLazy",

    -- https://cmp.saghen.dev/
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
        fuzzy = { implementation = "prefer_rust_with_warning" },
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
