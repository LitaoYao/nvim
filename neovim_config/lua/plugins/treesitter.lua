return {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- Last release is way too old
    -- tag = "v0.10.0",
    build = ':TSUpdate',
    -- event = { 'BufReadPost', 'BufNewFile' },
    lazy = false, -- Keep false to ensure loading for Neo-tree
    main = 'nvim-treesitter.configs', -- Lazy handles the require logic here
    branch = 'master', -- Explicitly force the stable branch
    opts_extend = { 'ensure_installed' },
    opts = {
        ensure_installed = { 'c', 'cpp', 'c_sharp', 'typescript', 'python', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'bash', 'hlsl' },
        sync_install = false,
        auto_install = true,
        ignore_install = { 'javascript' },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
    },
    -- Fallback config to handle edge cases
    config = function(_, opts)
        -- Protective call: If treesitter fails to load, don't crash neovim
        local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
        if not status_ok then
            return
        end
        configs.setup(opts)
    end,
}
