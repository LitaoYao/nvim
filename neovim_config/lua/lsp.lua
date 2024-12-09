-- lsp.lua

-- diagnostic
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
    end
})

-- lsp_signature
local lsp_signature = require("lsp_signature")
lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "rounded"
    }
})

-- mason
local mason = require("mason")
mason.setup()

-- mason_lspconfig
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({})

-- lspkind
local lspkind = require("lspkind")

-- nvim-autopairs
local npairs = require("nvim-autopairs")
npairs.setup({
    enable_check_bracket_line = false,
    ignored_next_char = "[%w%.]"
    })

-- cmp
local cmp = require("cmp")
cmp.setup({
    -- 设置代码片段引擎，用于根据代码片段补全
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
            -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    -- 按键映射
    mapping = {
        -- 选择上一个
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        -- 选择下一个
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- 出现补全
        ["<A-.>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
        -- 取消补全
        ["<A-,>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),

        -- 确认使用某个补全项
        ["<CR>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace
            }),

        -- 向上翻页
        ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
        -- 向下翻页
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
    },
    -- 补全来源
    sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "vsnip" }, -- For vsnip users.
            -- { name = "luasnip" }, -- For luasnip users.
            -- { name = "ultisnips" }, -- For ultisnips users.
            -- { name = "snippy" }, -- For snippy users.
        }, {
            { name = "buffer" },
        }),
    -- 设置补全显示的格式
    formatting = {
        format = lspkind.cmp_format({
                with_text = true,
                maxwidth = 50,
                ellipsis_char = "...",
                show_labelDetails = true,
                before = function(entry, vim_item)
                    vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
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

-- lspconfig
local lspconfig = require("lspconfig")

-- cmp_nvim_lsp
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- python3
lspconfig.pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {"W391", "W191", "E302", "E305", "E501"},
                    maxLineLength = 100
                }
            }
        }
    }
})

-- C#

-- roslyn
local roslyn = require("roslyn")
roslyn.setup({
    config = {
        -- Here you can pass in any options that that you would like to pass to `vim.lsp.start`.
        -- Use `:h vim.lsp.ClientConfig` to see all possible options.
        -- The only options that are overwritten and won't have any effect by setting here:
        --     - `name`
        --     - `cmd`
        --     - `root_dir`
    },

    --[[
    -- if you installed `roslyn-ls` by nix, use the following:
      exe = 'Microsoft.CodeAnalysis.LanguageServer',
    ]]
    exe = {
        "dotnet",
        vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
    },
    args = {
        "--logLevel=Information", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
    },
    --[[
    -- args can be used to pass additional flags to the language server
    ]]

    -- NOTE: Set `filewatching` to false if you experience performance problems.
    -- Defaults to true, since turning it off is a hack.
    -- If you notice that the server is _super_ slow, it is probably because of file watching
    -- Neovim becomes super unresponsive on some large codebases, because it schedules the file watching on the event loop.
    -- This issue goes away by disabling this capability, but roslyn will fallback to its own file watching,
    -- which can make the server super slow to initialize.
    -- Setting this option to false will indicate to the server that neovim will do the file watching.
    -- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
    -- a lot faster to initialize.
    filewatching = true,

    -- Optional function that takes an array of solutions as the only argument. Return the solution you
    -- want to use. If it returns `nil`, then it falls back to guessing the solution like normal
    -- Example:
    --
    -- choose_sln = function(sln)
    --     return vim.iter(sln):find(function(item)
    --         if string.match(item, "Foo.sln") then
    --             return item
    --         end
    --     end)
    -- end
    choose_sln = nil,

    -- Optional function that takes the selected solution as the only argument.
    -- Returns a boolean of whether it should be ignored to attach to or not
    --
    -- I am for example using this to disable a solution with a lot of .NET Framework code on mac
    -- Example:
    --
    -- ignore_sln = function(sln)
    --     return string.match(sln, "Foo.sln") ~= nil
    -- end
    ignore_sln = nil,

    -- Whether or not to look for solution files in the child of the (root).
    -- Set this to true if you have some projects that are not a child of the
    -- directory with the solution file
    broad_search = false,

    -- Whether or not to lock the solution target after the first attach.
    -- This will always attach to the target in `vim.g.roslyn_nvim_selected_solution`.
    -- NOTE: You can use `:Roslyn target` to change the target
    lock_target = false,
})

-- -- csharp_ls
-- lspconfig.csharp_ls.setup{}

-- -- omnisharp
-- local pid = vim.fn.getpid()
-- local omnisharp_bin = "C:/Program Files/OmniSharp/OmniSharp"
-- lspconfig.omnisharp.setup{
--     cmd = { omnisharp_bin, "--languageserver"},
--     on_attach = function(client, bufnr)
--         -- Enable completion triggered by <c-x><c-o>
--         vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

--         -- Mappings.
--         -- See `:help vim.lsp.*` for documentation on any of the below functions
--         local opts = { noremap=true, silent=true }
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
--         vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
--     end,
--     settings = {
--         FormattingOptions = {
--             -- Enables support for reading code style, naming convention and analyzer
--             -- settings from .editorconfig.
--             EnableEditorConfigSupport = true,
--             -- Specifies whether 'using' directives should be grouped and sorted during
--             -- document formatting.
--             OrganizeImports = nil,
--         },
--         MsBuild = {
--             -- If true, MSBuild project system will only load projects for files that
--             -- were opened in the editor. This setting is useful for big C# codebases
--             -- and allows for faster initialization of code navigation features only
--             -- for projects that are relevant to code that is being edited. With this
--             -- setting enabled OmniSharp may load fewer projects and may thus display
--             -- incomplete reference lists for symbols.
--             LoadProjectsOnDemand = nil,
--         },
--         RoslynExtensionsOptions = {
--             -- Enables support for roslyn analyzers, code fixes and rulesets.
--             EnableAnalyzersSupport = nil,
--             -- Enables support for showing unimported types and unimported extension
--             -- methods in completion lists. When committed, the appropriate using
--             -- directive will be added at the top of the current file. This option can
--             -- have a negative impact on initial completion responsiveness,
--             -- particularly for the first few completion sessions after opening a
--             -- solution.
--             EnableImportCompletion = nil,
--             -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
--             -- true
--             AnalyzeOpenDocumentsOnly = nil,
--         },
--         Sdk = {
--             -- Specifies whether to include preview versions of the .NET SDK when
--             -- determining which version to use for project loading.
--             IncludePrereleases = true,
--         },
--         capabilities = capabilities
--     },
-- }

-- C++
lspconfig.clangd.setup{}

-- TypeScript
local typescript_tools = require("typescript-tools")
local typescript_tools_api = require("typescript-tools.api")
typescript_tools.setup{
    -- on_attach = function() end,
    handlers = {
        ["textDocument/publishDiagnostics"] = typescript_tools_api.filter_diagnostics(
            -- 忽略 'This may be converted to an async function' 错误。
            { 80006 }
        ),
    },
    settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
            -- "remove_unused_imports"|"organize_imports") -- or string "all"
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
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
        },
        tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeCompletionsForModuleExports = true,
            quotePreference = "auto",
        },
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = "en",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
        }
    },
}

-- eslint
lspconfig.eslint.setup({
    optional = true,
    settings = {
        workingDirectory = {
            mode = "auto"
        },
        experimental = {
            useFaltConfig = true
        }
    }
})
