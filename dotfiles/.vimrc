colorscheme dark

set nocompatible
if has("win32")
    set shell=cmd
    set shellcmdflag=/c
    au GUIEnter * simalt ~x
else
    set shell=/bin/sh
endif

if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif
"set exrc
"set secure

set tags=~/.tags

set mouse=a
set sessionoptions=blank,buffers,curdir,folds,tabpages

set fileencodings=utf8
set encoding=utf8

if has("win32")
    set guifont=Consolas:h14
    set guioptions=aiet
    set showtabline=2
else
    set guifont=InconsolataLGC\ 14
    set guioptions=aie
    set showtabline=0
endif

set laststatus=2

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent

if &term =~ '^screen' && exists('$TMUX')
    set t_ku=OA
    set t_kd=OB
    set t_kr=OC
    set t_kl=OD
    set tenc=utf8
    autocmd BufReadPost,FileReadPost,BufNewFile,BufWinEnter,BufEnter * call system("tmux rename-window 'vim " . expand("%") . "'")
    autocmd VimLeave * call system("tmux rename-window bash")
    set ttymouse=xterm2
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif
set iskeyword=@,48-57,_,192-255

filetype plugin indent on
syntax on

set linebreak
set ruler
set showcmd
set wildmenu
set showmode
set number
set hls
set cursorline

set noerrorbells
set visualbell
set t_vb=
set tm=500

set autoread
set noswapfile
set nobackup

set incsearch
set ignorecase
set showmatch

set completeopt=
set ww=b,s,<,>,[,]

set backspace=2

let g:tagbar_sort=0
let g:tagbar_left=0

let g:NERDTreeWinPos='left'
let g:NERDTreeShowHidden=1

let g:ycm_confirm_extra_conf=0
let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<Down>']

let g:easytags_file='~/.tags'
let g:easytags_updatetime_min=0
let g:easytags_updatetime_warn=0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_section_z = '[0x%02B] < %l/%L (%c)'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let g:airline_theme = 'lucius'

vnoremap <C-C> "+y
vnoremap <C-X> "+d
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <C-Z> <Esc>ui
imap <C-Y> <Esc><C-R>i
imap <C-S> <Esc>:w<CR>i

imap <C-F> <Esc>/

imap <C-Space> <C-X><C-U>

inoremap <C-W> <Esc><C-W>a
inoremap <C-H> <Left><Del>
inoremap <C-L> <C-O><C-L>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
vmap { S{
vmap ( S(
vmap [ S[
vmap " S"
vmap ' S'

nmap <F2> <C-]>
imap <F2> <Esc><C-]>i

nmap <F4> :A!<CR>
vmap <F4> <Esc>:A!<CR>
imap <F4> <Esc>:A!<CR>i

nmap <F5> :YcmDiags<CR>
imap <F5> <C-O>:YcmDiags<CR>
nmap <F6> :lclose<CR>
imap <F6> <C-O>:lclose<CR>

nmap <F7> :NERDTreeToggle<CR>
imap <F7> <Esc>:NERDTreeToggle<CR>a
nmap <F8> :TagbarToggle<CR>
imap <F8> <Esc>:TagbarToggle<CR>a

function! MakeSession()
    if (argc() == 0)
        exe "mksession! " $HOME . "/.vim/.session"
    endif
endfunction

function! LoadSession()
    let b:session = $HOME . "/.vim/.session"
    if (argc() == 0 && filereadable(b:session))
        exe 'source ' b:session
    endif
endfunction

autocmd BufWinEnter *.c,*.h,*.cpp,*.hpp,*.cxx,*.cc inoremap { {}<Left><CR><CR><Up><Tab>
autocmd BufWinLeave * inoremap { {}<Left>
autocmd BufWinLeave * call clearmatches()

autocmd VimEnter * nested :call LoadSession()
autocmd VimLeave * :call MakeSession()

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
