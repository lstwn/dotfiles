-- TODO: rewrite in lua
-- resource: https://github.com/VonHeikemen/dotfiles/blob/master/my-configs/neovim/lua/local/session.lua

vim.cmd [[
set sessionoptions-=options " do not store vimrc stuff in session files
set sessionoptions-=terminal " do not store terminal stuff in session files (because does not restore ++kill=term currently)
function s:make_session() abort
    let l:session_dir = s:get_session_dir()
    if (filewritable(l:session_dir) != 2)
        silent call mkdir(l:session_dir, 'p')
    endif
    execute 'mksession! ' . s:get_session_file_path(l:session_dir)
endfunction

function s:restore_session() abort
    let l:session_dir = s:get_session_dir()
    let l:session_file_path = s:get_session_file_path(l:session_dir)
    if (filereadable(l:session_file_path))
        silent execute 'source ' . l:session_file_path
        echo 'Session restored for ' . fnamemodify(getcwd(), ":~") . '@' . luaeval('require("utils").git_branch()')
    else
        echo 'No session restored for ' . fnamemodify(getcwd(), ":~") . '@' . luaeval('require("utils").git_branch()')
    endif
endfunction

function s:get_session_dir()
    return stdpath('data') . '/sessions' . getcwd() . luaeval('require("utils").git_branch()')
endfunction

function s:get_session_file_path(base_dir)
    return a:base_dir . '/session.vim'
endfunction

augroup restore
    autocmd!
    " for remembering the last opened position
    autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " for remembering the last session
    if (argc() == 0)
        autocmd VimEnter * nested call s:restore_session()
    endif
    autocmd VimLeave * call s:make_session()
augroup END
]]
