vim.lsp.enable "lua_ls"           -- lua
vim.lsp.enable "clangd"           -- c/c++
vim.lsp.enable "zls"              -- zig
vim.lsp.enable "rust_analyzer"    -- rust
vim.lsp.enable "tombi"            -- toml
vim.lsp.enable "ty"               -- python
vim.lsp.enable "bashls"           -- bash
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
vim.api.nvim_create_user_command("LspRestart", function(info)
    local client_names = info.args

    -- Default to restarting all active servers
    if #client_names == 0 then
      client_names = vim
        .iter(vim.lsp.get_clients())
        :map(function(client)
          return client.name
        end)
        :totable()
    end

    for name in vim.iter(client_names) do
      if vim.lsp.config[name] == nil then
        vim.notify(("Invalid server name '%s'"):format(name))
      else
        vim.lsp.enable(name, false)
        if info.bang then
          vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
            client:stop(true)
          end)
        end
      end
    end

    local timer = assert(vim.uv.new_timer())
    timer:start(500, 0, function()
      for name in vim.iter(client_names) do
        vim.schedule_wrap(vim.lsp.enable)(name)
      end
    end)
end, {
     desc = 'Restart the given client (just for 0.11.6)',
    nargs = '?',
    bang = true,
})

-- TODO checkhealth

local function lsp_attach(_)
    vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
        signs = true,
        -- FIXME 波浪线无法显示
        underline = true,
        update_in_insert = false,
    })
    -- Auto [d ]d goto diagnostic
    vim.keymap.set("n", "E", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
end
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = lsp_attach,
})

