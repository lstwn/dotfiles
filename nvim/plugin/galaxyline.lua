local galaxyline = require("galaxyline")
local conditions = require("galaxyline.conditions")
local formatters = require("galaxyline.formatters")
local file = require("galaxyline.providers.file")
local set = require("galaxyline.set")
local mode = require("galaxyline.mode")

-- local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require("galaxyline.provider_vcs")
-- local fileinfo = require('galaxyline.provider_fileinfo')
-- local extension = require('galaxyline.provider_extensions')
-- local buffer = require('galaxyline.provider_buffer')
-- local whitespace = require('galaxyline.provider_whitespace')
-- local lspclient = require('galaxyline.provider_lsp')

-- TODO:
-- trailing ws only if normal mode

galaxyline.context = function()
    return {
        is_active_window = conditions.is_active_window(),
        has_active_lsp = conditions.has_active_lsp(),
        is_git_workspace = conditions.is_git_workspace(),
        mode = mode.current_mode(),
        filetype = vim.bo.filetype,
        buftype = vim.bo.buftype,
    }
end

local function is_active_window(context) return context.is_active_window end

local function has_active_lsp(context) return context.has_active_lsp end

local function is_git_workspace(context) return context.is_git_workspace end

local function wrap(string, _) return formatters.wrap(string, " ", " ") end

local function join_and_wrap_sequence(sequence, context)
    return wrap(formatters.join_sequence(sequence, " "), context)
end

local function active_inactive_highlight(active, inactive)
    return function(context)
        if context.is_active_window then return active end
        return inactive
    end
end

galaxyline.section.left = {
    {
        name = "Project",
        priority = 0,
        condition = is_active_window,
        provider = file.current_working_dir_name,
        formatter = wrap,
        highlight = active_inactive_highlight("StatusLineEnc", "StatusLineNC"),
    }, {
        name = "BufferNumber",
        priority = 80,
        provider = file.buffer_number,
        formatter = wrap,
        highlight = active_inactive_highlight("StatusLineBufNo", "StatusLineNC"),
    }, {
        name = "Mode",
        priority = 90,
        condition = is_active_window,
        provider = function(context) return context.mode.long_name end,
        formatter = wrap,
        highlight = active_inactive_highlight("StatusLineMode", "StatusLineNC"),
    }, {
        name = "Filename",
        priority = 100,
        condition = conditions.buffer_not_empty,
        provider = function(context)
            local file_name = context.is_active_window and file.file_name() or
                                  file.relative_path_and_file_name()
            local modified = file.is_modified()
            local readonly = file.is_readonly()
            return {file_name, modified, readonly}
        end,
        abbreviate = function(raw, space)
            local file_name = raw[1]
            local compensation = 6
            if raw[2] ~= "" then compensation = compensation + 2 end
            if raw[3] ~= "" then compensation = compensation + 2 end
            raw[1] = formatters.abbreviate(file_name, space and
                (space - compensation) or 15, "left")
            return raw
        end,
        formatter = join_and_wrap_sequence,
        highlight = active_inactive_highlight("StatusLineFile", "StatusLineNC"),
    }, {
        name = "GitBranch",
        priority = 50,
        condition = function(context)
            return is_git_workspace(context) and is_active_window(context)
        end,
        provider = vcs.get_git_branch,
        formatter = function(result)
            return wrap(formatters.abbreviate(result, 25))
        end,
        highlight = active_inactive_highlight("StatusLineInfo", "StatusLineNC"),
    }, {
        name = "Hunks",
        priority = 10,
        condition = is_git_workspace,
        provider = function()
            if vim.fn.exists("b:gitsigns_status") ~= 1 then return {} end

            local gitsigns_dict = vim.api.nvim_buf_get_var(0, "gitsigns_status")
            local added = tonumber(gitsigns_dict:match("+(%d+)")) or 0
            local modified = tonumber(gitsigns_dict:match("~(%d+)")) or 0
            local deleted = tonumber(gitsigns_dict:match("-(%d+)")) or 0

            added = added > 0 and added .. "A" or nil
            modified = modified > 0 and modified .. "M" or nil
            deleted = deleted > 0 and deleted .. "D" or nil
            return {added, modified, deleted}
        end,
        formatter = join_and_wrap_sequence,
        highlight = active_inactive_highlight("TabLine", "StatusLineNC"),
    },
}

local no_file_format_modes = set {mode.modes.terminal, mode.modes.command}
local no_file_format_buftypes = set {"quickfix"}

galaxyline.section.right = {
    {
        name = "Diagnostics",
        priority = 60,
        condition = has_active_lsp,
        provider = function()
            local diagnostic_types = {
                {type = "Hint", name = "H"}, {type = "Information", name = "I"},
                {type = "Warning", name = "W"}, {type = "Error", name = "E"},
            }

            local diagnostics = {}
            for i = 1, #diagnostic_types do
                local type = diagnostic_types[i].type
                local name = diagnostic_types[i].name
                local count = vim.lsp.diagnostic.get_count(0, type)
                if count ~= 0 then
                    diagnostics[i] = count .. name
                else
                    diagnostics[i] = ""
                end
            end
            return diagnostics
        end,
        formatter = join_and_wrap_sequence,
        highlight = active_inactive_highlight("TabLine", "StatusLineNC"),
    }, {
        name = "Options",
        priority = 30,
        condition = is_active_window,
        provider = function()
            local paste = vim.go.paste and "PASTE" or nil
            local spell = vim.wo.spell and
                              vim.api.nvim_buf_get_option(0, "spelllang"):upper() or
                              nil
            return {paste, spell}
        end,
        formatter = join_and_wrap_sequence,
        highlight = "StatusLineFlags",
    }, {
        name = "FileFormat",
        priority = 40,
        condition = function(context)
            return context.is_active_window and
                       not no_file_format_modes.contains(context.mode) and
                       not no_file_format_buftypes.contains(context.buftype)
        end,
        provider = function()
            local filetype = file.file_type():upper()
            local encode = file.file_encoding():upper()
            local format = file.file_format():upper()
            return {filetype, encode, format}
        end,
        formatter = join_and_wrap_sequence,
        highlight = "StatusLineFile",
    }, {
        name = "Location",
        priority = 70,
        provider = function() return file.line_column_position() end,
        formatter = wrap,
        highlight = active_inactive_highlight("StatusLineLoc", "StatusLineNC"),
    },
}
