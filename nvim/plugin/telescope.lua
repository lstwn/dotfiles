local telescope = require("telescope")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")

require("mappings").telescope()

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

telescope.load_extension("aerial")
telescope.load_extension('lsp_handlers')

local delta_file = previewers.new_termopen_previewer {
    get_command = function(entry)
        return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--',
            entry.current_file }
    end
}

local delta_commit = previewers.new_termopen_previewer {
    get_command = function(entry)
        return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
    end
}

telescope.setup {
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case",
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            height = 0.8,
            width = 0.9,
            horizontal = { mirror = false },
            vertical = { mirror = false },
            prompt_position = "bottom",
        },
        file_sorter = sorters.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        winblend = 0,
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        mappings = {
            i = {
                -- To disable a keymap, put [map] = false
                ["<C-x>"] = false,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
            },
            n = {
                ["<C-x>"] = false,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
            },
        },
    },
    pickers = {
        buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = { i = { ["<C-x>"] = actions.delete_buffer } },
        },
        git_commits = {
            previewer = delta_file,
        },
        git_bcommits = {
            previewer = delta_file,
        },
        git_status = {
            previewer = delta_commit,
        },
    },
    extensions = {
        aerial = {
            -- Display symbols as <root>.<parent>.<symbol>
            show_nesting = {
                ['_'] = true, -- This key will be the default
                json = true,  -- You can set the option for specific filetypes
                yaml = true,
            }
        },
    }
}
