local opt = vim.opt

-- UI tweaks

-- disable vim's internal mode display
opt.showmode = false
-- expose a title
opt.title = true
-- -- force 256 colours
-- opt.t_Co = 256
-- two lines for cmd entry
opt.cmdheight = 2
-- always show tab line
opt.showtabline = 2
-- always show statusline
opt.laststatus = 2
-- show cursurline
opt.cursorline = true
-- show diagnostics in sign column
opt.signcolumn = "yes"
-- show relative line numbers
opt.number = true
opt.relativenumber = true
-- prefer right split
opt.splitright = true
-- prefer bottom split
opt.splitbelow = true
-- window defaults
opt.winwidth = 4
opt.winminwidth = 4
opt.winheight = 3
opt.winminheight = 3
-- cursor to viewport offset when scrolling
opt.scrolloff = 10
-- chars to show at various positions
opt.fillchars = {
    -- stl = ' ', -- statusline of the current window
    -- stlnc = ' ', -- or '='	statusline of the non-current windows
    -- wbr = ' ', -- window bar
    -- horiz = '─', --	horizontal separators |:split|
    -- horizup = '┴', -- upwards facing horizontal separator
    -- horizdown = '┬', --	downwards facing horizontal separator
    -- vert = '│', -- vertical separators |:vsplit|
    -- vertleft = '┤', -- left facing vertical separator
    -- vertright = '├', --	right facing vertical separator
    -- verthoriz = '┼', --	overlapping vertical and horizontal separator
    -- fold = '·', -- filling 'foldtext'
    -- foldopen = '-', -- mark the beginning of a fold
    -- foldclose = '+', -- show a closed fold
    -- foldsep = '│', -- open fold middle marker
    -- diff = '-', -- deleted lines of the 'diff' option
    -- msgsep = ' ', -- message separator 'display'
    -- lastline = '@', --'display' contains lastline/truncate
    eob = ' ', -- empty lines at the end of a buffer
}
-- how to display whitespace chars
opt.listchars = { eol = "↲", tab = ">·", trail = "~", extends = ">", precedes = "<", space = "␣" }
vim.cmd.colorscheme("terminal")

-- UX tweaks

-- swap changed buffers without !
opt.hidden = true
-- displays an option on what to do instead of a plain error
opt.confirm = true
-- automatically load file changes, undo with 'u'
opt.autoread = true
-- backspace over everything
opt.backspace = { "indent", "eol", "start" }
-- default fold method
opt.foldmethod = "manual"
-- wildmenu settings
vim.cmd("set wildchar=<Tab>")
opt.wildignorecase = true
opt.wildignore:append({
    "*.bmp", "*.gif", "*.ico", "*.jpg", "*.png", "*.ico",
    "*.pdf", "*.psd", "*.class", "node_modules/*"
})
-- tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
-- use spaces instead of tabs
opt.expandtab = true
-- disable netrw (must happen early in the init process)
vim.g.loaded_netrwPlugin = 1

-- search tweaks

-- case-insensitive search by default
opt.ignorecase = true
-- case-sensitive search if search term contains a capital letter
opt.smartcase = true
-- show intermediate search results in buffer as you type
opt.incsearch = true
-- highlight search results
opt.hlsearch = true
-- show amount of search results
opt.shortmess:remove("S")
-- search and gotos continue from the top after hitting bot
opt.wrapscan = true

local settings_augroup = vim.api.nvim_create_augroup('settings_tweaks', { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    group = settings_augroup,
    command = "startinsert | setlocal nonumber norelativenumber signcolumn=no colorcolumn=0"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = settings_augroup,
    command = 'set norelativenumber | set colorcolumn=""'
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = settings_augroup,
    command = 'if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif'
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = settings_augroup,
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 800 })
    end,
})

-- automatically open quickfix list window if populated
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    group = settings_augroup,
    command = 'nested cwindow'
})

-- automatically open location list window if populated
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "l*",
    group = settings_augroup,
    command = 'nested lwindow'
})
