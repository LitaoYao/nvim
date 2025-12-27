return {
    -- 基础插件
    { 'vim-scripts/a.vim' },
    { 'ledger/vim-ledger' },
    { 'ervandew/supertab' },
    { 'petertriho/nvim-scrollbar' },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' }
    },
    { 'Tastyep/structlog.nvim' },
    { 'windwp/nvim-autopairs' },
    { 'mfussenegger/nvim-dap' },
    { 'nvim-neotest/nvim-nio' },
    { 'rcarriga/nvim-dap-ui' },
    { 'microsoft/vscode-js-debug', build = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out' },
    { 'voldikss/vim-translator' },
    { 'mhinz/vim-startify' },
    { 'nvim-tree/nvim-web-devicons' },
}
