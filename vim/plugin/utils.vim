if exists('g:loaded_utils') || &compatible
    finish
endif
let g:loaded_utils = 1

function s:CopyToSystemClipboard() abort
    let l:text = escape(@", ' "  \')
    let l:job = job_start("wl-copy ".l:text)
    let l:job = job_start("printf '%s' ".l:text." | xsel -ib")
endfunction

augroup utils
    autocmd!
    autocmd TextYankPost * call <SID>CopyToSystemClipboard()
augroup END

function g:Preserve(command) abort
    let l:cursor = getcurpos()
    execute 'keepjumps keeppatterns '.a:command
    call setpos('.', l:cursor)
endfunction

command -nargs=0 IndentFile call g:Preserve('normal gg=G')

function s:TrimTrailingWhitespace() range abort
    execute 'keepjumps keeppatterns ' . a:firstline . ',' . a:lastline 's/\s\+$//e'
endfunction
command -range=% -nargs=0 TrimTrailingWhitespace let b:view = winsaveview() |
            \ <line1>,<line2>call <SID>TrimTrailingWhitespace() |
            \ call winrestview(b:view) | unlet b:view


if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
    command -nargs=+ -complete=file -bar Grep silent! lgrep <args>|lopen|redraw!
else
    command -nargs=+ -complete=file -bar Grep silent! lvimgrep <args> **|lopen
endif

