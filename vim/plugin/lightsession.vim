if exists('g:loaded_lightsession') || &compatible
  finish
endif
let g:loaded_lightsession = 1

function s:make_session() abort
    let l:session_dir = s:get_session_dir()
    if (filewritable(l:session_dir) != 2)
        silent call mkdir(l:session_dir, 'p')
    endif
    exe 'mksession! ' . s:get_session_file_path(l:session_dir)
endfunction

function s:restore_session() abort
    let l:session_file_path = s:get_session_file_path(s:get_session_dir())
    if (filereadable(l:session_file_path))
        silent execute 'source ' . l:session_file_path
        echo 'Session restored for ' . getcwd()
    else
        echo 'No session restored for ' . getcwd()
    endif
endfunction

function s:get_session_dir()
    return $HOME . '/.vim/sessions' . getcwd()
endfunction

function s:get_session_file_path(base_dir)
    return a:base_dir . '/session.vim'
endfunction

augroup restore
    autocmd!
    " for remembering the last opened position
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " for remembering the last session
    if (argc() == 0)
        autocmd VimEnter * nested call s:restore_session()
    endif
    autocmd VimLeave * call s:make_session()
augroup END

