
-- TODO NVIM_MINIMAL
local nvim_minimal = false

local github_mirror = "https://gh-proxy.org/"

-- https://lazy.folke.io/
local function require_lazy()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    local url = github_mirror .. "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      url, lazypath,
    })
    if vim.v.shell_error ~= 0 then
      error("Failed to clone lazy.nvim:\n" .. out)
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.runtimepath:prepend(lazypath)
  return require("lazy")
end

---@param cond boolean
-- TODO @param priority? number
---@return table
local function plugin_onedark(cond)
    -- https://github.com/navarasu/onedark.nvim
    return {
      "navarasu/onedark.nvim",
      cond = cond,
      lazy = false,
      priority = 1000,
      opts = {},
      init = function() require("onedark").load() end
    }
end

---@param cond boolean
---@return table
local function plugin_nvim_autopairs(cond)
  -- https://github.com/windwp/nvim-autopairs
  return {
    "windwp/nvim-autopairs",
    cond = cond,
    lazy = true,
    event = "InsertEnter",
    opts = {}
  }
end

---@param cond boolean
---@return table
local function plugin_nvim_treesitter(cond)
  -- https://github.com/nvim-treesitter/nvim-treesitter
  -- required: tar, curl; CC; tree-sitter-cli
  -- 使用 :InspectTree 显示语法树
    return {
      "nvim-treesitter/nvim-treesitter",
      cond = cond,
      lazy = false,
      priority = 900,
      build = ":TSUpdate",
      init = function()
        local languages = {
         "lua", "c", "rust", "zig" , "python", "bash",
        }
        require("nvim-treesitter").install(languages)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = languages,
          callback = function()
            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            vim.wo.foldenable = true
            vim.wo.foldlevel = 99
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldmethod = 'expr'
            -- TODO foldtext
            -- TODO foldcolumn
          end
        })
      end
    }
end

---@param cond boolean
---@return table
local function plugin_blink_cmp(cond)
  -- https://github.com/Saghen/blink.cmp
  -- https://cmp.saghen.dev/
  return {
    "saghen/blink.cmp",
    cond = cond,
    lazy = true,
    event = "UIEnter",
    version = "1.*",

    opts = {
      keymap = { preset = "super-tab" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true, window = { show_documentation = true } },
      completion = {
        menu = {
          auto_show = true,
        },
        documentation = {
          auto_show = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "super-tab" },
        completion = { menu = { auto_show = true } },
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
      },
    },
  }
end

---@param cond boolean
local function plugin_indent_blankline(cond)
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    cond = cond,
    lazy = false,
    opts = {}
  }
end

---@param cond boolean
local function plugin_outline(cond)
  -- https://github.com/hedyhli/outline.nvim
  return {
    "hedyhli/outline.nvim",
    cond = cond,
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "go", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        auto_width = { enabled = false, max_width = 40 },
        wrap = false,
      },
      outline_items = {
        show_symbol_details = false,
      },
      preview_window = { live = true, },
      -- symbols = {
      --   icon_fetcher = function() return "" end,
      -- }
      -- TODO 统一按键
      -- keymaps = {
      -- }
      -- providers = {}
    }
  }
end

---@param cond boolean
local function plugin_lualine(cond)
  -- https://github.com/nvim-lualine/lualine.nvim
  return {
    "nvim-lualine/lualine.nvim",
    cond = cond,
    lazy = false,
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = ''},
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "diagnostics",
            sources = { "nvim_workspace_diagnostic" },
            sections = { "error", "warn" },
            update_in_insert = true,
            always_visible = true,
          }
        },
        lualine_c = { "branch", "filename" },
        lualine_x = { "progress", { "location", fmt = function(s) return s:match(":(.*)") end }, },
        lualine_y = { "encoding", "filetype" },
        lualine_z = { "lsp_status" },
      },
    },
  }
end


---@param cond boolean
local function plugin_gitsigns(cond)
  -- https://github.com/lewis6991/gitsigns.nvim
  return {
    "lewis6991/gitsigns.nvim",
    cond = cond,
    lazy = true,
    event = "UIEnter",
    opts = {
      signcolumn = false,
      numhl = true,
      current_line_blame = false,
    }
  }
end

---@param cond boolean
local function plugin_fidget(cond)
  -- https://github.com/j-hui/fidget.nvim
  return {
    "j-hui/fidget.nvim",
    cond = cond,
    opts = { notification = { override_vim_notify = true } },
  }
end

local function plugin_nvim_telescope(cond)
  -- https://github.com/nvim-telescope/telescope.nvim
  return {
    "nvim-telescope/telescope.nvim",
    cond = cond,
    lazy = true,
    event = "UIEnter",
    -- TODO nvim-telescope/telescope-lsp.nvim
    -- TODO fzf-navtive
    dependencies = {
      "nvim-lua/plenary.nvim",
      "j-hui/fidget.nvim",
    },
    opts = {
      defaults = {
        -- initial_mode = "normal", -- (*insert, normal)
      },
      pickers = {},
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("fidget")
      vim.keymap.set('n', '<leader>fn', function() telescope.extensions.fidget.fidget({
        -- FIXME 通知预览无法自动换行
        wrap_text = true,
        initial_mode = "normal",
      }) end,{ desc = 'Telescope notifications' })

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-P>', function() builtin.builtin({
        preview = false,
      }) end, { desc = "Telescope builtin pickers" })
      vim.keymap.set('n', '<leader>ff', function() builtin.find_files({
      }) end, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fc', function() builtin.find_files({
        cwd = vim.fn.stdpath("config"),
      }) end, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({
        path_display = { "tail" },
      }) end, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', function() builtin.buffers({
        initial_mode = "normal",
        preview = false,
        select_current = true,
        -- FIXME path_display 不生效
      }) end, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fs', function() builtin.treesitter({
        ignore_symbols = { "associated", "parameter", },
      }) end,{ desc = 'Telescope treesitter' })
      vim.keymap.set('n', '<leader>fd', function() builtin.diagnostics({
        initial_mode = "normal",
      }) end,{ desc = 'Telescope diagnostics' })

      -- LSP
      vim.keymap.set('n', 'gri', function() builtin.lsp_implementations(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Goto implementations' })
      vim.keymap.set('n', 'grr', function() builtin.lsp_references(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Goto references' })
      vim.keymap.set('n', 'grt', function() builtin.lsp_type_definitions(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Goto type definitions' })
      vim.keymap.set('n', 'gO', function() builtin.lsp_document_symbols({
        ignore_symbols = { },
      }) end, { desc = 'Goto document symbols' })
      vim.keymap.set('n', 'gd', function() builtin.lsp_definitions(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Goto definitions' })
    end
  }
end

local lazy = require_lazy()
lazy.setup({
  git = { url_format = github_mirror .. "https://github.com/%s.git" },
  install = { missing = false, colorscheme = { "onedark" } },
  spec = {
    plugin_onedark(true),
    plugin_nvim_autopairs(true),
    plugin_nvim_treesitter(true),
    plugin_blink_cmp(true),
    plugin_indent_blankline(not nvim_minimal),
    plugin_outline(not nvim_minimal),
    plugin_lualine(not nvim_minimal),
    plugin_gitsigns(not nvim_minimal),
    plugin_fidget(not nvim_minimal),
    plugin_nvim_telescope(not nvim_minimal),
  }
})
