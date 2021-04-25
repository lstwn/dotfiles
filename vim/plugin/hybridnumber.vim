if exists('g:loaded_hybridnumber') || &compatible
  finish
endif
let g:loaded_hybridnumber = 1

set number relativenumber
augroup hybridnumber
    autocmd!
    autocmd WinEnter,FocusGained,InsertLeave * if (&l:buftype !=# 'terminal' && &l:filetype !=# 'netrw' && &l:filetype !=# 'help') | setlocal number relativenumber | endif
    autocmd WinLeave,FocusLost,InsertEnter * if (&l:buftype !=# 'terminal' && &l:filetype !=# 'netrw' && &l:filetype !=# 'help') | setlocal number norelativenumber | endif
augroup END

