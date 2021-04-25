if exists('g:loaded_undoswapback') || &compatible
  finish
endif
let g:loaded_undoswapback = 1

let s:undo_dir   = get(g:, 'undo_dir', $HOME . '/.vim/undo')
let s:swap_dir   = get(g:, 'swap_dir', $HOME . '/.vim/swap')
let s:backup_dir = get(g:, 'backup_dir', $HOME . '/.vim/backup')

if !isdirectory(s:swap_dir)
    silent call mkdir(s:swap_dir, 'p')
endif

if !isdirectory(s:undo_dir)
    silent call mkdir(s:undo_dir, 'p')
endif

if !isdirectory(s:backup_dir)
    silent call mkdir(s:backup_dir, 'p')
endif

execute "set directory=" . s:swap_dir
execute "set undodir=" . s:undo_dir
execute "set backupdir=" . s:backup_dir

function s:delete_swap_file() abort
    let l:name = substitute(expand('%:p'), '/', '%', 'g')
    let l:path = s:swap_dir . '/' . l:name . '.swp'
    let l:command = 'rm ' . l:path
    let l:result = system(l:command)
    echo 'Deleted swap file for ' . expand('%:p')
endfunction

command -nargs=0 DeleteSwapFile call s:delete_swap_file()
