---@class LazyConfig
---@field [1]? LazySpec[]
---@field spec? LazySpec[] (default nil) 若通过位置参数 1 传入 spec，则保持该成员为 nil
---@field git? LazyConfigGit
---@field install? LazyConfigInstall
---@field checker? LazyConfigChecker
---@field change_detection? LazyConfigChangeDetection

---@class LazyConfigGit
---@field url_format? string (default "http://github.com/%s.git")

---@class LazyConfigInstall
---@field missing? boolean (default true) 启动时，自动安装缺失插件
---@field colorscheme? string[] (default `{ "habamax" }`) 启动时，尝试应用的主题

---@class LazyConfigChecker
---@field enabled? boolean (default false) 启用自动检查插件更新
---@field concurrency? number (default nil)
---@field notify? boolean (default true) 是否在发现可更新插件时通知
---@field frequency? integer (default 3600) 检查更新间隔的秒
---@field check_pinned? boolean (default false) 是否检查 pinned package

---@class LazyConfigChangeDetection
---@field enabled? boolean (default true) 启用配置文件自动检查并重新加载 UI
---@field notify? boolean (default true)

---@class LazySpec
---@field [1] string 插件名称，将结合 `config.git.url_format` 拓展
---@field dependencies? string[] 依赖
-- @field dependencies? LazySpec[] 依赖
---@field enabled? boolean|(fun(): boolean) 是否加载该插件
---@field cond? boolean|(fun(lazy_plugin: any): boolean) 是否加载该插件；不会卸载该插件
---@field init? fun(lazy_plugin: any) 插件生命周期钩子: 启动时
---@field config? fun(lazy_plugin: any, opts: table)
---@field build? (fun(lazy_plugin: any))|string 插件生命周期钩子: 安装或更新时
---@field opts? table|fun(lazy_plugin: any, opts: table)
---@field lazy? boolean 是否懒加载
---@field version? string|boolean (default true)
---@field import? string 批量导入指定 Spec 模块 (替换)，若使用，则不需配置以下内容
