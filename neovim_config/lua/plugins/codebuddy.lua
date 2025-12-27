return {
    dir = vim.fn.stdpath('data') .. '/../nvim/pack/gongfeng/start/vim',
    name = 'CodeBuddy',
    lazy = true,
    event = 'InsertEnter',
    cmd = { 'CodeBuddy' },
}
