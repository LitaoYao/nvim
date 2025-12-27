return {
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
}
