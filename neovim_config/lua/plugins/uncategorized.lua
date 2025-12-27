return {
    -- 基础插件
    { 'vim-scripts/a.vim' },
    {
        'dense-analysis/ale',
        config = function()
            vim.g.ale_python_flake8_executable = 'python'
            vim.g.ale_python_flake8_options = '-m flake8 --ignore=E101,E117,E12,E20,E22,E23,E24,E25,E26,E30,E402,E501,E502,E722,E731,W191,W293,W292,W391 --builtins=_tr'
            vim.g.ale_set_loclist = 0
            vim.g.ale_set_quickfix = 1
            vim.g.ale_lint_on_insert_leave = 1
            vim.g.ale_sign_column_always = 0
            vim.g.ale_set_highlights = 0
            vim.g.ale_lint_on_text_changed = 'never'
            vim.g.ale_lint_on_enter = 0
            vim.g.ale_lint_on_save = 1
            vim.g.ale_sign_error = '✗'
            vim.g.ale_sign_warning = '⚡'
            vim.g.ale_linters = {
                python = { 'flake8' },
                cpp = { 'gcc' },
                c = { 'gcc' },
                typescript = { 'eslint' },
                javascript = { 'eslint' }
            }
            vim.g.ale_fixers = {
                python = { 'flake8' },
                cpp = { 'gcc' },
                c = { 'gcc' },
                typescript = { 'eslint' },
                javascript = { 'eslint' }
            }
        end
    },
    { 'ledger/vim-ledger' },
    { 'flazz/vim-colorschemes' },
    { 'ervandew/supertab' },
    { 'preservim/nerdcommenter' },
    {
        'dyng/ctrlsf.vim',
        config = function()
            vim.g.ctrlsf_auto_preview = 1
            vim.g.ctrlsf_absolute_file_path = 1
            vim.g.ctrlsf_extra_root_markers = { '.project', 'package.json' }
            vim.g.ctrlsf_default_root = 'project+fw'
            vim.g.ctrlsf_ignore_dir = { 'tmp', 'log', 'bin' }
        end
    },
    { 'beyondmarc/hlsl.vim' },
    { 'petertriho/nvim-scrollbar' },
    { 
        'mason-org/mason.nvim',
        opt = {}
    },
    { 'neovim/nvim-lspconfig' },
    {
        'mason-org/mason-lspconfig.nvim',
        opts = {},
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'neovim/nvim-lspconfig',
        },
    },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/nvim-cmp' },
    { 'onsails/lspkind-nvim' },
    {
        'nvim-lua/plenary.nvim',
        build = 'make'
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' }
    },
    {
        'folke/tokyonight.nvim',
        lazy = true,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tokyonight')
        end
    },
    { 'projekt0n/github-nvim-theme' },
    { 'pmizio/typescript-tools.nvim' },
    { 'iabdelkareem/csharp.nvim' },
    { 'Tastyep/structlog.nvim' },
    { 'nvim-tree/nvim-tree.lua' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'akinsho/bufferline.nvim', tag = '*' },
    { 'windwp/nvim-autopairs' },
    { 'rmagatti/goto-preview' },
    { 'ray-x/lsp_signature.nvim' },
    { 'mfussenegger/nvim-dap' },
    { 'nvim-neotest/nvim-nio' },
    { 'rcarriga/nvim-dap-ui' },
    { 'microsoft/vscode-js-debug', build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out' },
    {
        'voldikss/vim-floaterm',
        config = function()
            vim.g.floaterm_width = 0.9
            vim.g.floaterm_height = 0.9
        end
    },
    {
        'SirVer/ultisnips',
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<tab>'
            vim.g.UltiSnipsJumpForwardTrigger = '<c-b>'
            vim.g.UltiSnipsJumpBackwardTrigger = '<c-z>'
            vim.g.UltiSnipsEditSplit = 'vertical'
        end
    },
    {
        'iamcco/markdown-preview.nvim',
        build = 'nvim -c \'call mkdp#util#install()\' -c q'
    },
    { 'voldikss/vim-translator' },
    { 'mhinz/vim-startify' },
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
}
