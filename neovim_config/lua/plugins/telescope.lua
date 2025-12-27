local actions = require('telescope.actions')
return {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    keys = {
        { '<leader>f', '<CMD>Telescope find_files<CR>', desc = 'Telescope find files' },
        { '<leader>b', '<CMD>Telescope buffers<CR>', desc = 'Telescope buffers' },
        { '<leader>p', '<CMD>Telescope lsp_document_symbols<CR>', desc = 'Telescope lsp_document_symbols' },
        { '<leader>r', '<CMD>Telescope lsp_references<CR>', desc = 'Telescope lsp references' },
    },
    opts = {
        defaults = {
            initial_mode = 'insert',
            path_display = {
                filename_first = {
                    reverse_directories = false,
                },
            },
            layout_strategy = 'vertical',
            layout_config = {
                height = 0.95,
                width = 0.95,
            },
            mappings = {
                i = {
                    ['<c-d>'] = actions.delete_buffer,
                },
                n = {
                    ['dd'] = actions.delete_buffer,
                }
            },
            preview = {
                treesitter = false,
            }
        }
    }
}
