-- 设置leader键
vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('configs.lazy')
require('configs.basic')
require('configs.keymap')
require('configs.user_command')
require('configs.dap_config')
require('configs.uncategorized')
require('configs.lsp')
