-- lsp.lua

-- mason
local mason = require("mason")
mason.setup()

-- mason_lspconfig
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({})

-- lspkind
local lspkind = require("lspkind")

-- cmp
local cmp = require'cmp'
cmp.setup({
        -- 设置代码片段引擎，用于根据代码片段补全
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
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
                    before = function(entry, vim_item)
                        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                        return vim_item
                    end
                }),
        },
    })

-- lspconfig
local lspconfig = require("lspconfig")

-- python3
lspconfig.pylsp.setup{
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
}

-- C#
lspconfig.csharp_ls.setup{}
