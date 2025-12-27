-- svn
vim.api.nvim_create_user_command(
    'SvnUpdate',
    function(opts)
        local path = opts.args
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:update /path:' .. vim.fn.shellescape(path), { detach = true })
    end,
    { nargs = '?', complete = 'file' }
)
vim.api.nvim_create_user_command(
    'SvnLog',
    function(opts)
        local path = opts.args
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:log /path:' .. vim.fn.shellescape(path), { detach = true })
    end,
    { nargs = '?', complete = 'file' }
)
vim.api.nvim_create_user_command(
    'SvnCommit',
    function(opts)
        local path = opts.args
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:commit /path:' .. vim.fn.shellescape(path), { detach = true })
    end,
    { nargs = '?', complete = 'file' }
)
vim.api.nvim_create_user_command(
    'SvnBlame',
    function(opts)
        local path = opts.args
        local line = opts.line1
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:blame /path:' .. vim.fn.shellescape(path) .. ' /startrev:1 /endrev:HEAD /line:' .. line, { detach = true })
    end,
    { nargs = '?', complete = 'file', range = true }
)
vim.api.nvim_create_user_command(
    'SvnRevert',
    function(opts)
        local path = opts.args
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:revert /path:' .. vim.fn.shellescape(path), { detach = true })
    end,
    { nargs = '?', complete = 'file' }
)
vim.api.nvim_create_user_command(
    'SvnCleanup',
    function(opts)
        local path = opts.args
        if path == '' then
            path = vim.fn.expand('%p')
        end
        vim.fn.jobstart('start tortoiseProc /command:cleanup /path:' .. vim.fn.shellescape(path), { detach = true })
    end,
    { nargs = '?', complete = 'file' }
)
