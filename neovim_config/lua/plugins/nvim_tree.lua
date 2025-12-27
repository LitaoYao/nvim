return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup({
                actions = {
                    open_file = {
                        resize_window = true,
                    },
                },
            })
        end,
        keys = {
            { '<leader>d', function() vim.cmd('NvimTreeToggle') end, desc = 'Toggle Nvim-Tree' },
            { '<leader>e', function() vim.cmd('NvimTreeToggle %:p:h') end, desc = 'Find File in Nvim-Tree' },
        },
    },
    { 'nvim-tree/nvim-web-devicons' },
}
