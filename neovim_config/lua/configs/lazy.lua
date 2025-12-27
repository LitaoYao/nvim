local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = {
        { import = 'plugins' },
    },
    install = {
        colorscheme = {
            'tokyonight-moon',
        }
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip', 'tar', 'zip', 'netrw', 'netrwPlugin', 'netrwSettings',
                'tarPlugin', 'zipPlugin', 'zip', 'tutor', 'rplugin', 'spellfile',
                'getscript', 'getscriptPlugin', 'vimball', 'vimballPlugin', 'matchit'
            }
        }
    }
})
