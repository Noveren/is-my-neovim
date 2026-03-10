
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
      -- lazy = true,
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
          -- lsp, path, snippets, buffer
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

local function plugin_nvim_telescope(cond)
  return {
    "nvim-telescope/telescope.nvim",
    cond = cond,
    -- TODO nvim-telescope/telescope-lsp.nvim
    -- TODO outline
    -- TODO fzf-navtive
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        -- initial_mode = "normal", -- (*insert, normal)
      },
      pickers = { },
    },
    init = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<C-P>', builtin.builtin, { desc = "Telescope builtin pickers" })
      vim.keymap.set('n', '<leader>ff', function() builtin.find_files({
      }) end, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fc', function() builtin.find_files({
        cwd = vim.fn.stdpath("config"),
      }) end, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', function() builtin.live_grep({
      }) end, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', function() builtin.buffers({
        initial_mode = "normal",
        select_current = true,
        -- FIXME path_display 不生效
      }) end, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fs', function() builtin.treesitter({
        ignore_symbols = { "associated", "parameter", },
      }) end,{ desc = 'Telescope treesitter' })
      vim.keymap.set('n', '<leader>ss', function() builtin.lsp_document_symbols({
        ignore_symbols = { },
      }) end, { desc = 'Telescope lsp document symbols' })
      vim.keymap.set('n', 'gd', function() builtin.lsp_definitions(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Telescope lsp definitions' })
      vim.keymap.set('n', 'grr', function() builtin.lsp_references(
        require("telescope.themes").get_cursor({ initial_mode = "normal", path_display = { "tail" } })
      ) end, { desc = 'Telescope lsp references' })
    end
  }
end

local lazy = require_lazy()
lazy.setup({
  git = { url_format = github_mirror .. "https://github.com/%s.git" },
  install = { missing = true, colorscheme = { "onedark" } },
  spec = {
    -- vim.tbl_extend(),
    plugin_onedark(true),
    plugin_nvim_autopairs(true),
    plugin_nvim_treesitter(true),
    plugin_blink_cmp(true),
    plugin_nvim_telescope(not nvim_minimal),
  }
})
