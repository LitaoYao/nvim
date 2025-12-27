return {
    { 'flazz/vim-colorschemes' },
    {
        'folke/tokyonight.nvim',
        lazy = true,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme('tokyonight')
        end
    },
    { 'projekt0n/github-nvim-theme' },
}
