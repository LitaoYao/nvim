-- dap.lua

-- mason-nvim-dap
-- require('mason-nvim-dap').setup({
--     ensure_installed = { 'js' },  -- 自动安装js-debug-adapter
-- })

-- require('dap-vscode-js').setup({
--   -- node_path = 'node', -- Path of node executable. Defaults to $NODE_PATH, and then 'node'
--   debugger_path = 'C:/Users/bobyao/AppData/Local/nvim-data/plugged/vscode-js-debug', -- Path to vscode-js-debug installation.
--   -- debugger_cmd = { 'js-debug-adapter' }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--   -- log_file_path = '(stdpath cache)/dap_vscode_js.log' -- Path for file logging
--   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
--   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })

-- 动态获取项目根目录
local get_workspace_folder = function()
    local cwd = vim.fn.getcwd()
    local markers = { 'package.json', 'tsconfig.json' }
    for _, marker in ipairs(markers) do
        local root = vim.fn.finddir(marker, cwd .. ';')
        if root ~= '' then
            return vim.fn.fnamemodify(root, ':h')
        end
    end
    return cwd
end

-- dap
local dap = require('dap')
local dap_utils = require('dap.utils')

local workspace_folder = get_workspace_folder()

-- dap.adapters['pwa-node'] = {
--     type = 'server',
--     host = 'localhost',
--     port = '${port}',
--     executable = {
--         command =  vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter.cmd',
--         args = {
--             '${port}',
--         },
--     },
-- }

dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
        command =  'node',
        args = { 'C:/Users/bobyao/AppData/Local/nvim-data/plugged/vscode-js-debug/out/src/vsDebugServer.js', '${port}' },
    },
}

for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach to PuerTS',
            address = 'localhost',
            port = 9229,
            cwd = workspace_folder,
            restart = true,
            pauseForSourceMap = false,
            resolveSourceMapLocations = nil,
            sourceMapPathOverrides = {
                ['InGamePath:JS/*'] = workspace_folder .. '/Build/.localbuild/SRC/Domestic/*.map',
                ['rollup://@tencent/pixide-puerts-framework/*'] = workspace_folder .. '/BaseScripts/Shared/GameFramework/*',
                ['rollup://@tencent/tv-websocket/*'] = workspace_folder .. '/BaseScripts/Domestic/TV/tv-websocket/*',
                ['rollup://@tencent/tv-httprequest/*'] = workspace_folder .. '/BaseScripts/Domestic/TV/tv-httprequest/*',
                ['rollup://@tencent/tv-player/*'] = workspace_folder .. '/BaseScripts/Domestic/TV/tv-player/*',
                ['rollup://@tencent/tv-module/*'] = workspace_folder .. '/BaseScripts/Domestic/TV/tv-module/*',
                ['rollup://@tencent/tga-puer/*'] = workspace_folder .. '/BaseScripts/Domestic/TV/tga-puer/*'
            },
            timeout = 30000,
            trace = true,
        }
    }
end

-- dapui
local dapui = require('dapui')

-- 初始化dap-ui
dapui.setup()

-- 自动打开/关闭调试界面
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- 快捷键
vim.keymap.set('n', '<leader><F8>', dapui.toggle)
vim.keymap.set('n', '<leader><F5>', dap.continue)
vim.keymap.set('n', '<leader><F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader><F10>', dap.step_over)
vim.keymap.set('n', '<leader><F11>', dap.step_into)
vim.keymap.set('n', '<leader><F12>', dap.step_out)
