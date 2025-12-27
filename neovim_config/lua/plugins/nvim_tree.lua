return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { '<leader>d', function() vim.cmd('NvimTreeToggle') end, desc = 'Toggle Nvim-Tree' },
            { '<leader>e', function() vim.cmd('NvimTreeToggle %:p:h') end, desc = 'Find File in Nvim-Tree' },
        },
        opts = {
            actions = {
                open_file = {
                    resize_window = true,
                },
            },
        },
    },
    { 'nvim-tree/nvim-web-devicons' },
}
