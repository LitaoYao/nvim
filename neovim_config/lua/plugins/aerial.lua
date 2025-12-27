return {
    'stevearc/aerial.nvim',
    opts = function()
        ---@type table<string, string[]>|false
        local filter_kind = false
        local opts = {
            attach_mode = "global",
            backends = { "lsp", "treesitter", "markdown", "man" },
            show_guides = true,
            layout = {
                resize_to_content = false,
                win_opts = {
                    winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
                    signcolumn = "yes",
                    statuscolumn = " ",
                },
            },
            icons = icons,
            filter_kind = filter_kind,
            -- stylua: ignore
            guides = {
                mid_item   = "├╴",
                last_item  = "└╴",
                nested_top = "│ ",
                whitespace = "  ",
            },
        }
        return opts
    end,
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
}
