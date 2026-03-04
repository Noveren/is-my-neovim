
local function vim_enter_snacks()
    local no_args = (vim.fn.argc(-1) == 0)
    -- local is_path = (vim.fn.argc(-1) > 0
    --     and vim.fn.isdirectory(vim.fn.argv(0) --[[@as string]]) == 1)
    -- local no_bufs = (vim.fn.bufnr() == 0)
    -- local no_stdin = (vim.fn.line2byte("$") ~= -1)
    -- Snacks.dashboard.open()
    if no_args then
        Snacks.explorer.open()
    end
end

local progress = vim.defaulttable()
local function advanced_lsp_progress(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
        return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
            p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                    value.kind == "end" and 100 or value.percentage or 100,
                    value.title or "",
                    value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
            }
            break
        end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
            notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
    })
end

-- https://github.com/folke/snacks.nvim
---@type LazySpec
local lazy_spec = {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        ---@type snacks.indent.Config
        indent = { enabled = true, },
        ---@type snacks.statuscolumn.Config
        statuscolumn = {
            enabled = true,
            left = { "mark", "git", "fold" },
            right = { "sign" },
            folds = {
                open = true,
                git_hl = true,
            },
            git = { patterns = { "GitSign", "MiniDiffSign" } },
            refresh = 50, -- ms
        },
        ---@type snacks.terminal.Config
        terminal = { enabled = true, win = { position = "float" } },
        ---@type snacks.picker.Config
        picker = { enabled = true, focus = "input" },
        ---@type snacks.explorer.Config
        explorer = { enabled = true, exclude = {} },
        ---@type snacks.notifier.Config
        notifier = { enabled = true },
        ---@type snacks.quickfile.Config
        quickfile = { enabled = true },
    },
    config = function(_, opts)
        Snacks.setup(opts)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.api.nvim_create_autocmd("VimEnter", {
            group = vim.api.nvim_create_augroup("vim-enter-snacks", { clear = true }),
            callback = vim_enter_snacks,
        })
        vim.api.nvim_create_autocmd("LspProgress", {
            group = vim.api.nvim_create_augroup("advanced-lsp-progress", { clear = true }),
            callback = advanced_lsp_progress,
        })
    end,
    keys = {
        { "<C-t>", function() Snacks.terminal.toggle() end, desc = "Terminal Toggle."},
        { "<C-p>", function() Snacks.picker() end, desc = "Snacks Picker "},
        -- Top Pickers & Explorer
        -- { "<leader>f", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        -- { "<leader>,", function() Snacks.picker.buffers({ focus = "list" }) end, desc = "Buffers" },
        -- { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications({ focus = "list" }) end, desc = "Notification History" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        -- Find
        { "<leader>fb", function() Snacks.picker.buffers({ focus = "list" }) end, desc = "Buffers" },
        -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        -- { "<leader>fg", function() Snacks.picker.git_files({ focus = "list" }) end, desc = "Find Git Files" },
        -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        -- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- Git
        -- { "<leader>gb", function() Snacks.picker.git_branches({ focus = "list" }) end, desc = "Git Branches" },
        -- { "<leader>gl", function() Snacks.picker.git_log({ focus = "list" }) end, desc = "Git Log" },
        -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        -- { "<leader>gs", function() Snacks.picker.git_status({ focus = "list" }) end, desc = "Git Status" },
        -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        -- { "<leader>gd", function() Snacks.picker.git_diff({ focus = "list" }) end, desc = "Git Diff (Hunks)" },
        -- { "<leader>gf", function() Snacks.picker.git_log_file({ focus = "list" }) end, desc = "Git Log File" },
        -- -- Github
        -- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
        -- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
        -- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
        -- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        -- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        -- { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- Search
        -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        -- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics({ focus = "list" }) end, desc = "Diagnostics" },
        -- { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        -- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        -- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist({ focus = "list" }) end, desc = "Quickfix List" },
        -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo({ focus = "list" }) end, desc = "Undo History" },
        -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions({ focus = "list" }) end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations({ focus = "list" }) end, desc = "Goto Declaration" },
        { "gr", function() Snacks.picker.lsp_references({ focus = "list" }) end, nowait = true, desc = "References" },
        -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions({ focus = "list" }) end, desc = "Goto T[y]pe Definition" },
        -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
        -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols({ focus = "list" }) end, desc = "LSP Symbols" },
        -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
     },
}



return lazy_spec
