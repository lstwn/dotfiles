local utils = require("utils")

local provider = {}

function provider.current_working_dir()
    return "%{fnamemodify(getcwd(), ':t')}"
end

provider.term_label = "terminal"

function provider.mode()
    return "%{b:mode}"
end

vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged", "BufEnter" }, {
    callback = function()
        vim.b.mode = utils.current_mode().long_name:upper()
    end
})

function provider.git_branch()
    return "%{b:git_branch}"
end

vim.api.nvim_create_autocmd({ "VimEnter", "FileType", "BufEnter", "FocusGained" }, {
    callback = function()
        local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
        if branch ~= "" then
            vim.b.git_branch = branch
        else
            vim.b.git_branch = ""
        end
    end
})

function provider.file() return "%f" end

function provider.modified() return "%m" end

function provider.file_type() return "%.80{&filetype}" end

function provider.file_encoding() return "%{&fileencoding}" end

function provider.file_format() return "%{&fileformat}" end

function provider.position() return "%l/%L:%2v" end

function provider.term_title() return "%.80{b:term_title}" end

local fmt = {}

fmt.truncation_marker = "%<"

fmt.separation_marker = "%="

function fmt.wrap(s, with)
    with = with or " "
    if s == nil or s == "" then
        return ""
    end
    return with .. s .. with
end

function fmt.join(l, sep)
    return table.concat(l, sep)
end

function fmt.highlight(s, group)
    s = s or ""
    return "%#" .. group .. "#" .. s .. ""
end

function fmt.group(s)
    return "%(" .. s .. "%)"
end

local function map(f, l)
    local mapped = {}
    for i = 1, #l do
        mapped[i] = f(l[i])
    end
    return mapped
end

local active_term_stl = {
    -- left
    {
        fmt.highlight(fmt.wrap(provider.term_label), "StatusLineEnc"),
        fmt.highlight(fmt.wrap(provider.mode()), "StatusLineMode"),
        fmt.highlight("", "StatusLine"),
    },
    -- mid
    {
        fmt.truncation_marker,
        provider.term_title()
    },
    -- right
    {
        fmt.highlight("", "StatusLineFile"),
        fmt.wrap(provider.position()),
    },
}
local stringified_active_term_stl = fmt.join(
    map(function(l) return fmt.join(l, "") end, active_term_stl), fmt.separation_marker)

local active_buf_stl = {
    -- left
    {
        fmt.highlight(fmt.wrap(provider.current_working_dir()), "StatusLineEnc"),
        fmt.highlight(fmt.wrap(provider.mode()), "StatusLineMode"),
        -- fmt.group makes the whole thing disappear if vim isn't in a git folder
        fmt.highlight(fmt.group(fmt.wrap(provider.git_branch())), "StatusLineInfo"),
        fmt.highlight("", "StatusLine"),
    },
    -- mid
    {
        fmt.truncation_marker,
        provider.file(),
        " ",
        provider.modified()
    },
    -- right
    {
        fmt.highlight("", "StatusLineFile"),
        " ",
        provider.file_type(),
        " ",
        provider.file_encoding(),
        " ",
        provider.file_format(),
        " ",
        provider.position(),
        " ",
    },
}

local stringified_active_buf_stl = fmt.join(
    map(function(l) return fmt.join(l, "") end, active_buf_stl), fmt.separation_marker)

-- inactive part

local inactive_term_stl = {
    -- left
    { provider.term_label, },
    -- mid
    { fmt.truncation_marker, provider.term_title() },
    -- right
    { provider.position() },
}
local stringified_inactive_term_stl = fmt.wrap(fmt.join(
    map(function(l) return fmt.join(l, " ") end, inactive_term_stl), fmt.separation_marker))

local inactive_buf_stl = {
    -- left
    { provider.current_working_dir() },
    -- mid
    { fmt.truncation_marker,         provider.file(), provider.modified() },
    -- right
    { provider.position() },
}

local stringified_inactive_buf_stl = fmt.wrap(fmt.join(
    map(function(l) return fmt.join(l, " ") end, inactive_buf_stl), fmt.separation_marker))

function Status_Line()
    local active = tonumber(vim.g.actual_curwin) == vim.fn.win_getid()
    local term = vim.b.term_title

    if not term then
        if active then
            return stringified_active_buf_stl
        else
            return stringified_inactive_buf_stl
        end
    else
        if active then
            return stringified_active_term_stl
        else
            return stringified_inactive_term_stl
        end
    end
end

vim.opt.statusline = "%{%v:lua.Status_Line()%}"
