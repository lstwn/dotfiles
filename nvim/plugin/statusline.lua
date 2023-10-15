local utils = require("utils")
local diagnostic = vim.diagnostic

local provider = {}

-- makes vim evaluate the expression in e
function provider.make_expr(e) return "%{" .. e .. "}" end

-- makes vim evaluate the expression in e but also reinterpret the resulting string
-- in terms of the statusline syntax for highlight groups or known patterns
function provider.make_re_reactive(s) return "%{%" .. s .. "%}" end

provider.current_working_dir = provider.make_expr("g:stl_cwd")

-- BufEnter is required to have the buffer local variable initalized
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
        vim.g.stl_cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    end
})

provider.term_label = "terminal"

provider.mode = provider.make_expr("b:stl_mode")

-- BufEnter is required to have the buffer local variable initalized
vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged" }, {
    callback = function()
        vim.b.stl_mode = utils.current_mode().long_name:upper()
    end
})

provider.git_branch = provider.make_expr("b:git_branch")

-- BufEnter is required to have the buffer local variable initalized
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "FocusGained" }, {
    callback = function()
        vim.b.git_branch = utils.git_branch() or ""
    end
})

provider.diag_summary = provider.make_re_reactive("b:stl_diag_colorbox")

-- BufEnter is required to have the buffer local variable initalized
vim.api.nvim_create_autocmd({ "BufEnter", "DiagnosticChanged" }, {
    callback = function()
        local err_cnt = #diagnostic.get(vim.api.nvim_get_current_buf(), {
            severity = diagnostic.severity[diagnostic.severity.ERROR],
        }) or 0
        local warn_cnt = #diagnostic.get(vim.api.nvim_get_current_buf(), {
            severity = diagnostic.severity[diagnostic.severity.WARN],
        }) or 0

        if err_cnt > 0 then
            vim.b.stl_diag_colorbox = "%#RedBlock# " .. err_cnt .. " %#StatusLine#"
            return
        end

        if warn_cnt > 0 then
            vim.b.stl_diag_colorbox = "%#YellowBlock# " .. warn_cnt .. " %#StatusLine#"
            return
        end

        vim.b.stl_diag_colorbox = ""
    end,
})

provider.file = "%f"

provider.modified = "%m"

provider.file_type = "%.80{&filetype}"

provider.file_encoding = provider.make_expr("&fileencoding")

provider.file_format = provider.make_expr("&fileformat")

provider.position = "%l/%L:%2v"

provider.term_title = "%.80{b:term_title}"

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

function fmt.join(l, sep) return table.concat(l, sep) end

function fmt.highlight(s, group)
    s = s or ""
    return "%#" .. group .. "#" .. s .. ""
end

function fmt.group(s) return "%(" .. s .. "%)" end

local function map(f, l)
    local mapped = {}
    for i = 1, #l do
        mapped[i] = f(l[i])
    end
    return mapped
end

local active_buf_stl = {
    -- left
    {
        fmt.highlight(fmt.wrap(provider.current_working_dir), "MagentaBlock"),
        fmt.highlight(fmt.wrap(provider.mode), "GreenBlock"),
        -- fmt.group makes the whole thing disappear if vim isn't in a git folder
        fmt.highlight(fmt.group(fmt.wrap(provider.git_branch)), "YellowBlock"),
        fmt.highlight("", "StatusLine"),
    },
    -- mid
    {
        fmt.truncation_marker,
        provider.file,
        " ",
        provider.modified
    },
    -- right
    {
        provider.diag_summary,
        fmt.highlight("", "BlueBlock"),
        " ",
        provider.file_type,
        " ",
        provider.file_encoding,
        " ",
        provider.file_format,
        " ",
        provider.position,
        " ",
    },
}

local active_term_stl = {
    -- left
    {
        fmt.highlight(fmt.wrap(provider.term_label), "MagentaBlock"),
        fmt.highlight(fmt.wrap(provider.mode), "GreenBlock"),
        fmt.highlight("", "StatusLine"),
    },
    -- mid
    {
        fmt.truncation_marker,
        provider.term_title
    },
    -- right
    {
        fmt.highlight("", "BlueBlock"),
        fmt.wrap(provider.position),
    },
}
local stringified_active_term_stl = fmt.join(
    map(function(l) return fmt.join(l, "") end, active_term_stl), fmt.separation_marker)

local stringified_active_buf_stl = fmt.join(
    map(function(l) return fmt.join(l, "") end, active_buf_stl), fmt.separation_marker)

-- inactive part

local inactive_buf_stl = {
    -- left
    { provider.current_working_dir },
    -- mid
    { fmt.truncation_marker,       provider.file, provider.modified },
    -- right
    { provider.position },
}

local inactive_term_stl = {
    -- left
    { provider.term_label, },
    -- mid
    { fmt.truncation_marker, provider.term_title },
    -- right
    { provider.position },
}
local stringified_inactive_term_stl = fmt.wrap(fmt.join(
    map(function(l) return fmt.join(l, " ") end, inactive_term_stl), fmt.separation_marker))

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
