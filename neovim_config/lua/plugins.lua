-- scrollbar
require("scrollbar").setup()

-- -- nvim-tree
-- local nvim_tree = require("nvim-tree")
-- nvim_tree.setup({
--     sort_by = "case_sensitive",
--     -- 是否显示 git 状态
--     git = {
--         enable = true,
--     },
--     -- 过滤文件
--     filters = {
--         dotfiles = true, -- 过滤 dotfile
--         custom = { "node_modules" }, -- 其他过滤目录
--     },
--     view = {
--         -- 文件浏览器展示位置，左侧：left, 右侧：right
--         side = "left",
--         -- 行号是否显示
--         number = false,
--         relativenumber = false,
--         signcolumn = "yes", -- 显示图标
--         width = 30,
--     },
--     renderer = {
--         group_empty = true,
--     },
-- })
-- vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = 'Open Nvim Tree' })

-- bufferline
vim.opt.termguicolors = true
local bufferline = require('bufferline')
bufferline.setup({
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "none",
        close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf)  -- buf contains:
            -- name                | str        | the basename of the active file
            -- path                | str        | the full path of the active file
            -- bufnr (buffer only) | int        | the number of the active buffer
            -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
            -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
        end,
        max_name_length = 64,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 20,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if context.buffer:current() then
                return ''
            end
            local icon = level:match("error") and " " or ""
            return " " .. icon .. count
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                return true
            end
            -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
                return true
            end
        end,
        offsets = {
            {
                filetype = "defx",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        get_element_icon = function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            -- e.g.
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
        end,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
        duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
        persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        auto_toggle_bufferline = true,
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        -- sort_by = function(buffer_a, buffer_b)
        --     -- add custom logic
        --     return buffer_a.modified > buffer_b.modified
        -- end,
    }
})

-- Telescope
local function normalize_path(path)
    return path:gsub("\\", "/")
end

local function normalize_cwd()
    return normalize_path(vim.loop.cwd()) .. "/"
end

local function is_subdirectory(cwd, path)
    return string.lower(path:sub(1, #cwd)) == string.lower(cwd)
end

local function split_filepath(path)
    local normalized_path = normalize_path(path)
    local normalized_cwd = normalize_cwd()
    local filename = normalized_path:match("[^/]+$")

    if is_subdirectory(normalized_cwd, normalized_path) then
        local stripped_path = normalized_path:sub(#normalized_cwd + 1, -(#filename + 1))
        return stripped_path, filename
    else
        local stripped_path = normalized_path:sub(1, -(#filename + 1))
        return stripped_path, filename
    end
end

local function path_display(_, path)
    local stripped_path, filename = split_filepath(path)
    if filename == stripped_path or stripped_path == "" then
        return filename
    end
    return string.format("%s ~ %s", filename, stripped_path)
end

local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local telescope = require('telescope').setup({
    defaults = {
        initial_mode = "insert",
        path_display = {
            filename_first = {
                reverse_directories = false,
            },
        },
        layout_strategy = "vertical",
        layout_config = {
            height = 0.95,
            width = 0.95,
        },
        mappings = {
            i = {
                ["<c-d>"] = actions.delete_buffer,
            },
            n = {
                ["dd"] = actions.delete_buffer,
            }
        }
    }
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>p', builtin.lsp_document_symbols, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Telescope help tags' })

-- goto-preview
local goto_preview = require('goto-preview')
goto_preview.setup({
    default_mappings = true
})

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "cpp", "c_sharp", "typescript", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- -- the name of the parser)
    -- -- list of language that will be disabled
    -- disable = { "c", "rust" },
    -- -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
