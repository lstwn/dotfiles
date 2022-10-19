"""""""""""""""""""""""""""""""""""""""""""""""""
" lstwn's nVIM Configuration                    "
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" Plugins                             "
"""""""""""""""""""""""""""""""""""""""

lua require('plugins')

"""""""""""""""""""""""""""""""""""""""
" Options                             "
"""""""""""""""""""""""""""""""""""""""

let s:is_mac = 0
let s:is_linux = 0
if has("mac")
    let s:is_mac = 1
endif
if has("linux")
    let s:is_linux = 1
endif

if s:is_mac
    set clipboard=unnamed
endif
if s:is_linux
    set clipboard=unnamedplus
endif
set hidden " swap changed buffers without !
set confirm " displays an option on what to do instead of a plain error
set ignorecase " case-insensitive search by default
set smartcase " case-sensitive search if search term contains a capital letter
set nowrapscan
set incsearch
set hlsearch
set shortmess-=S " show amount of search results
set foldmethod=manual
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab " Use spaces instead of tabs
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set backspace=indent,eol,start " backspace over everything
set splitright
set splitbelow
set winwidth=4
set winminwidth=4
set winheight=3
set winminheight=3
set scrolloff=10
set autoread " automatically load file changes, undo with 'u'
set title
set colorcolumn=80
set t_Co=256
set cmdheight=2
set showtabline=2
set laststatus=2 " always display a statusline regardless of the amount of windows open
set noshowmode
set wildchar=<Tab>
set wildignorecase
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*.class
set wildignore+=node_modules/*
set ruler
set cursorline
set signcolumn=yes
set fillchars=eob:\ 
set number relativenumber
set shell=sh
augroup optiontweaks
    autocmd!
    autocmd TermOpen * startinsert | setlocal nonumber norelativenumber signcolumn=no colorcolumn=0
    autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
    autocmd FileType qf set norelativenumber | set colorcolumn=""
augroup END
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=800 }
augroup END
function s:append_terminal_colorscheme()
    highlight LspDiagnosticsDefaultError ctermfg=Red
    highlight LspDiagnosticsDefaultWarning ctermfg=Yellow
    highlight LspDiagnosticsDefaultInformation ctermfg=DarkGrey
    highlight LspDiagnosticsDefaultHint ctermfg=DarkGrey
    highlight QuickfixLine ctermfg=Yellow ctermbg=none
endfunction
augroup colortweaks
    autocmd!
    autocmd ColorScheme terminal call s:append_terminal_colorscheme()
augroup END
colorscheme terminal

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
    let l:session_file_path = s:get_session_file_path(s:get_session_dir())
    if (filereadable(l:session_file_path))
        silent execute 'source ' . l:session_file_path
        echo 'Session restored for ' . getcwd()
    else
        echo 'No session restored for ' . getcwd()
    endif
endfunction

function s:get_session_dir()
    return stdpath('data') . '/sessions' . getcwd()
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


"""""""""""""""""""""""""""""""""""""""
" Mappings                            "
"""""""""""""""""""""""""""""""""""""""

lua require('mappings').own()

"""""""""""""""""""""""""""""""""""""""
" commands                            "
"""""""""""""""""""""""""""""""""""""""

command! -nargs=0 -bar BufOnly silent %bd | silent e# | silent bd#

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

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

command -nargs=0 HighlightGroupsUnderCursor call SynStack()

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
    command -nargs=+ -complete=file -bar Grep silent! grep <args>|copen
else
    command -nargs=+ -complete=file -bar Grep silent! vimgrep <args> **|copen
endif

"""""""""""""""""""""""""""""""""""""""
" broot.vim                           "
"""""""""""""""""""""""""""""""""""""""

let g:broot_replace_netrw = 1
let g:loaded_netrwPlugin = 1
let g:broot_vim_conf = [
    \ 'default_flags = "gh"',
    \ 'modal = true',
    \ '',
	\ '[[verbs]]',
    \ 'key = "enter"',
    \ 'external = "echo +{line} {file}"',
    \ 'apply_to = "file"',
    \ ]
