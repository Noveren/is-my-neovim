
local function lsp_enable(name, opts)
  vim.lsp.config[name] = opts
  vim.lsp.enable(name)
end

local function lua()
  local runtime = {}
  local library = {}

  local path_config = vim.fn.expand(vim.fn.stdpath("config"))
  local path_startup_cwd = vim.fn.expand(vim.fn.getcwd())
  if vim.fs.relpath(path_config, path_startup_cwd) ~= nil then
    vim.notify("Set lua-language-server for neovim configuration.")
    runtime["version"] = "LuaJIT"
    table.insert(library, vim.fn.expand("$VIMRUNTIME/lua"))
    table.insert(library, vim.fn.expand("${3rd}/luv/library"))
    -- local runtimepaths = vim.split(vim.api.nvim_get_option_value("runtimepath", {}), ",")
    -- local lazypath = vim.fn.expand(vim.fn.stdpath("data") .. "/lazy")
    -- for _, path in ipairs(runtimepaths) do
    --   local _path = vim.fn.expand(path)
    --   if vim.fs.relpath(lazypath, _path) ~= nil then
    --     -- TODO 不添加所有插件
    --     table.insert(library, _path)
    --   end
    -- end
  end
  return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markders = { ".git" },
    settings = {
      Lua = {
        runtime = runtime,
        workspace = { checkTridParty = false, library = library },
      }
    },
  }
end

local function python()
  return {
   cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = {
      -- "pyproject.toml",
      ".venv",
      ".git"
    },
  }
end

local function toml()
  return {
   cmd = { "tombi", "lsp" },
    filetypes = { "toml" },
    root_markers = {
      ".git"
    },
  }
end

local function c()
  return {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      ".git",
    },
  }
end

local function bash()
  return {
    cmd = { 'bash-language-server', 'start' },
    settings = {
      bashIde = {
        -- Glob pattern for finding and parsing shell script files in the workspace.
        -- Used by the background analysis features across files.

        -- Prevent recursive scanning which will cause issues when opening a file
        -- directly in the home directory (e.g. ~/foo.sh).
        --
        -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
        globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
      },
    },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' },
  }
end

local function zig()
  return {
    cmd = { 'zls' },
    filetypes = { 'zig', },
    root_markers = { 'build.zig', '.git' },
    workspace_required = false,
  }
end

local function rust()
  local function reload_workspace(bufnr)
    local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
    for _, client in ipairs(clients) do
      vim.notify 'Reloading Cargo Workspace'
      ---@diagnostic disable-next-line:param-type-mismatch
      client:request('rust-analyzer/reloadWorkspace', nil, function(err)
        if err then
          error(tostring(err))
        end
        vim.notify 'Cargo workspace reloaded'
      end, 0)
    end
  end

  local function is_library(fname)
    local user_home = vim.fs.normalize(vim.env.HOME)
    local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
    local registry = cargo_home .. '/registry/src'
    local git_registry = cargo_home .. '/git/checkouts'

    local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
    local toolchains = rustup_home .. '/toolchains'

    for _, item in ipairs { toolchains, registry, git_registry } do
      if vim.fs.relpath(item, fname) then
        local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
        return #clients > 0 and clients[#clients].config.root_dir or nil
      end
    end
  end

  ---@type vim.lsp.Config
  return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local reused_dir = is_library(fname)
      if reused_dir then
        on_dir(reused_dir)
        return
      end

      local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
      local cargo_workspace_root

      if cargo_crate_dir == nil then
        on_dir(
          vim.fs.root(fname, { 'rust-project.json' })
          or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
        )
        return
      end

      local cmd = {
        'cargo',
        'metadata',
        '--no-deps',
        '--format-version',
        '1',
        '--manifest-path',
        cargo_crate_dir .. '/Cargo.toml',
      }

      vim.system(cmd, { text = true }, function(output)
        if output.code == 0 then
          if output.stdout then
            local result = vim.json.decode(output.stdout)
            if result['workspace_root'] then
              cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
            end
          end

          on_dir(cargo_workspace_root or cargo_crate_dir)
        else
          vim.schedule(function()
            vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
          end)
        end
      end)
    end,
    capabilities = {
      experimental = {
        serverStatusNotification = true,
        commands = {
          commands = {
            'rust-analyzer.showReferences',
            'rust-analyzer.runSingle',
            'rust-analyzer.debugSingle',
          },
        },
      },
    },
    settings = {
      ['rust-analyzer'] = {
        lens = {
          debug = { enable = true },
          enable = true,
          implementations = { enable = true },
          references = {
            adt = { enable = true },
            enumVariant = { enable = true },
            method = { enable = true },
            trait = { enable = true },
          },
          run = { enable = true },
          updateTest = { enable = true },
        },
      },
    },
    before_init = function(init_params, config)
      -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
      if config.settings and config.settings['rust-analyzer'] then
        init_params.initializationOptions = config.settings['rust-analyzer']
      end
      ---@param command table{ title: string, command: string, arguments: any[] }
      vim.lsp.commands['rust-analyzer.runSingle'] = function(command)
        local r = command.arguments[1]
        local cmd = { 'cargo', unpack(r.args.cargoArgs) }
        if r.args.executableArgs and #r.args.executableArgs > 0 then
          vim.list_extend(cmd, { '--', unpack(r.args.executableArgs) })
        end

        local proc = vim.system(cmd, { cwd = r.args.cwd, r.args.environment })

        local result = proc:wait()

        if result.code == 0 then
          vim.notify(result.stdout, vim.log.levels.INFO)
        else
          vim.notify(result.stderr, vim.log.levels.ERROR)
        end
      end
    end,
    on_attach = function(_, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
        reload_workspace(bufnr)
      end, { desc = 'Reload current cargo workspace' })
    end,
  }
end

local function lsp()
  -- https://neovim.io/doc/user/lsp
  -- 默认全局按键映射
  -- + gra vim.lsp.buf.code_action()
  -- + gri vim.lsp.buf.implementaion()   跳转到实现
  -- + grn vim.lsp.buf.rename()
  -- + grr vim.lsp.buf.references()      列出引用位置
  -- + grt vim.lsp.buf.type_definition() 跳转到类型定义
  -- + gO  vim.lsp.buf.document_symbol() 列出文档符号
  -- + Insert Mode: <C-s> vim.lsp.buf.signatrue_help()
  -- + vim.lsp.buf.selection_range()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function()
      vim.diagnostic.config({
        virtual_text = true,
        virtual_lines = false,
        signs = true,
        -- FIXME 波浪线无法显示
        underline = true,
        update_in_insert = false,
      })
      -- n K vim.lsp.buf.hover()
      vim.keymap.set("n", "gh", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local diagnostics = vim.diagnostic.get(bufnr , { line = line })
        if #diagnostics > 0 then
          vim.diagnostic.open_float()
          return
        end
        vim.lsp.buf.hover({ silent = true })
      end, { remap = true, desc = "Show" })
    end,
  })

  lsp_enable("lua_ls", lua())
  lsp_enable("ty", python())
  lsp_enable("tombi", toml())
  lsp_enable("clangd", c())
  lsp_enable("bashls",bash())
  lsp_enable("zls", zig())
  lsp_enable("rust_analyzer", rust())
end lsp()
