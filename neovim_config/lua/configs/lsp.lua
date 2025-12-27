-- lsp.lua

-- vim.lsp.buf
vim.keymap.set('n', '<F2>', ':lua vim.lsp.buf.rename()<CR>')

-- diagnostic
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- lsp_signature
local lsp_signature = require('lsp_signature')
lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = 'rounded'
    }
})
vim.keymap.set(
    'n',
    '<leader>1',
    function()
        lsp_signature.toggle_float_win()
    end,
    {
        silent = true,
        noremap = true,
        desc = 'toggle signature'
    }
)

-- -- mason
-- local mason = require('mason')
-- mason.setup()

-- -- mason_lspconfig
-- local mason_lspconfig = require('mason-lspconfig')
-- mason_lspconfig.setup({})

-- lspkind
local lspkind = require('lspkind')

-- nvim-autopairs
local npairs = require('nvim-autopairs')
npairs.setup({
    enable_check_bracket_line = false,
    ignored_next_char = '[%w%.]'
    })

-- cmp
local cmp = require('cmp')
cmp.setup({
    -- 设置代码片段引擎，用于根据代码片段补全
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
        end,
    },
    -- 按键映射
    mapping = {
        -- 选择上一个
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- 选择下一个
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- 出现补全
        ['<A-.>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        -- 取消补全
        ['<A-,>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),

        -- 确认使用某个补全项
        ['<CR>'] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace
            }),

        -- 向上翻页
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        -- 向下翻页
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
    },
    -- 补全来源
    sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        }),
    -- 设置补全显示的格式
    formatting = {
        format = lspkind.cmp_format({
                with_text = true,
                maxwidth = 50,
                ellipsis_char = '...',
                show_labelDetails = true,
                before = function(entry, vim_item)
                    vim_item.menu = '[' .. string.upper(entry.source.name) .. ']'
                    return vim_item
                end
            }),
    },
})
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

-- cmp_nvim_lsp
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local capabilities = cmp_nvim_lsp.default_capabilities()

-- python3
vim.lsp.config('pylsp', {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391', 'W191', 'E302', 'E305', 'E501'},
                    maxLineLength = 100
                }
            }
        }
    }
})

-- C#

-- csharp.nvim
require('csharp').setup({
    lsp = {
        -- Sets if you want to use omnisharp as your LSP
        omnisharp = {
        -- When set to false, csharp.nvim won't launch omnisharp automatically.
            enable = true,
            -- When set, csharp.nvim won't install omnisharp automatically. Instead, the omnisharp instance in the cmd_path will be used.
            cmd_path = nil,
            -- The default timeout when communicating with omnisharp
            default_timeout = 1000,
            -- Settings that'll be passed to the omnisharp server
            enable_editor_config_support = true,
            organize_imports = true,
            load_projects_on_demand = false,
            enable_analyzers_support = true,
            enable_import_completion = true,
            include_prerelease_sdks = true,
            analyze_open_documents_only = false,
            enable_package_auto_restore = true,
            -- Launches omnisharp in debug mode
            debug = false,
        },
        -- Sets if you want to use roslyn as your LSP
        roslyn = {
            -- When set to true, csharp.nvim will launch roslyn automatically.
            enable = false,
            -- Path to the roslyn LSP see 'Roslyn LSP Specific Prerequisites' above.
            cmd_path = nil,
        },
        -- The capabilities to pass to the omnisharp server
        capabilities = nil,
        -- on_attach function that'll be called when the LSP is attached to a buffer
        on_attach = nil
    },
    logging = {
        -- The minimum log level.
        level = 'off',
    },
    dap = {
        -- When set, csharp.nvim won't launch install and debugger automatically. Instead, it'll use the debug adapter specified.
        --- @type string?
        adapter_name = nil,
    }
})

-- roslyn
-- local roslyn = require('roslyn')
-- roslyn.setup({
--     config = {
--         -- Here you can pass in any options that that you would like to pass to `vim.lsp.start`.
--         -- Use `:h vim.lsp.ClientConfig` to see all possible options.
--         -- The only options that are overwritten and won't have any effect by setting here:
--         --     - `name`
--         --     - `cmd`
--         --     - `root_dir`
--     },

--     [>
--     -- if you installed `roslyn-ls` by nix, use the following:
--     exe = 'Microsoft.CodeAnalysis.LanguageServer',
--     ]]
--     exe = {
--         'dotnet',
--         vim.fs.joinpath(vim.fn.stdpath('data'), 'roslyn', 'Microsoft.CodeAnalysis.LanguageServer.dll'),
--     },
--     args = {
--         '--logLevel=Information', '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path())
--     },
--     [>
--     -- args can be used to pass additional flags to the language server
--     ]]

--     -- 'auto' | 'roslyn' | 'off'
--     --
--     -- - 'auto': Does nothing for filewatching, leaving everything as default
--     -- - 'roslyn': Turns off neovim filewatching which will make roslyn do the filewatching
--     -- - 'off': Hack to turn off all filewatching. (Can be used if you notice performance issues)
--     filewatching = 'auto',

--     -- Optional function that takes an array of targets as the only argument. Return the target you
--     -- want to use. If it returns `nil`, then it falls back to guessing the target like normal
--     -- Example:
--     --
--     -- choose_target = function(target)
--     --     return vim.iter(target):find(function(item)
--     --         if string.match(item, 'Foo.sln') then
--     --             return item
--     --         end
--     --     end)
--     -- end
--     choose_target = nil,

--     -- Optional function that takes the selected target as the only argument.
--     -- Returns a boolean of whether it should be ignored to attach to or not
--     --
--     -- I am for example using this to disable a solution with a lot of .NET Framework code on mac
--     -- Example:
--     --
--     -- ignore_target = function(target)
--     --     return string.match(target, 'Foo.sln') ~= nil
--     -- end
--     ignore_target = nil,

--     -- Whether or not to look for solution files in the child of the (root).
--     -- Set this to true if you have some projects that are not a child of the
--     -- directory with the solution file
--     broad_search = false,

--     -- Whether or not to lock the solution target after the first attach.
--     -- This will always attach to the target in `vim.g.roslyn_nvim_selected_solution`.
--     -- NOTE: You can use `:Roslyn target` to change the target
--     lock_target = false,
-- })

-- -- csharp_ls
-- vim.lsp.config('csharp_ls', {})

-- omnisharp
-- local pid = vim.fn.getpid()
-- local omnisharp_bin = 'C:/Program Files/OmniSharp/OmniSharp.exe'
-- vim.lsp.config('omnisharp', {
--     cmd = { omnisharp_bin, '--languageserver' },
--     settings = {
--         MsBuild = {
--             LoadProjectsOnDemand = true, -- 按需加载项目
--         },
--         RoslynExtension = {
--             EnableRoslynAnalyzers = true, -- 启用高级代码分析
--         }
--     },
-- }

-- C++
vim.lsp.config('clangd', {})

-- TypeScript
local typescript_tools = require('typescript-tools')
local typescript_tools_api = require('typescript-tools.api')
typescript_tools.setup{
    -- on_attach = function() end,
    handlers = {
        ['textDocument/publishDiagnostics'] = typescript_tools_api.filter_diagnostics(
            -- 忽略 'This may be converted to an async function' 错误。
            { 80006 }
        ),
    },
    settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- 'change'|'insert_leave' determine when the client asks the server about diagnostic
        publish_diagnostic_on = 'insert_leave',
        -- array of strings('fix_all'|'add_missing_imports'|'remove_unused'|
            -- 'remove_unused_imports'|'organize_imports') -- or string 'all'
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = {},
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or 'auto'(basically no limit)
        tsserver_max_memory = 'auto',
        -- described below
        tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
        },
        tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeCompletionsForModuleExports = true,
            quotePreference = 'auto',
        },
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = 'en',
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ('off'|'all'|'implementations_only'|'references_only')
        code_lens = 'off',
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
            enable = false,
            filetypes = { 'javascriptreact', 'typescriptreact' },
        }
    },
}

-- eslint
vim.lsp.config('eslint', {
    optional = true,
    settings = {
        workingDirectory = {
            mode = 'auto'
        },
        experimental = {
            useFaltConfig = true
        }
    }
})
