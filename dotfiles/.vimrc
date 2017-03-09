colorscheme dark

set nocompatible
if has("win32")
    set shell=cmd
    set shellcmdflag=/c
    au GUIEnter * simalt ~x
    let vimfiles = '$HOME/vimfiles'
else
    set shell=/bin/sh
    let vimfiles = '~/.vim'
    let &makeprg = 'if [ -f Makefile ]; then make; else make -C build; fi'
endif

call plug#begin(vimfiles . '/bundle/')
if has("win32")
    Plug 'thaerkh/vim-workspace'
else
    Plug 'Valloric/YouCompleteMe'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-easytags'
    Plug 'majutsushi/tagbar'
endif

Plug 'scrooloose/nerdtree'

Plug 'vim-scripts/TaskList.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'

Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-endwise'
Plug 'terryma/vim-multiple-cursors'

Plug 'kien/ctrlp.vim'
Plug 'a.vim'

Plug 'ifdef-highlighting'
Plug 'syntaxdosini.vim'
Plug 'elzr/vim-json'
Plug 'pavel-belikov/vim-qmake'
Plug 'pavel-belikov/vim-qtcreator-tasks'

Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

set tags=~/.tags

set mouse=a
set sessionoptions=blank,buffers,curdir,folds,tabpages

set fileencodings=utf8,cp1251
set encoding=utf8

if has("win32")
    set guifont=Consolas:h14
    set guioptions=ait
    set showtabline=2
else
    set guifont=InconsolataLGC\ 14
    set guioptions=ait
    set showtabline=0
endif

set laststatus=2

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent

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

set completeopt=
set ww=b,s,<,>,[,]
set iskeyword=@,48-57,_,192-255
set backspace=2

filetype plugin indent on
syntax on

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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_min_count = 2

let g:airline_theme = 'lucius'

let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|CMakeFiles)$'

let g:delimitMate_expand_cr = 1

let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup=1

let g:cpp_experimental_template_highlight = 1

vnoremap <C-C> "+y
vnoremap <C-X> "+d
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
imap <C-Z> <Esc>ui
imap <C-Y> <Esc><C-R>i
imap <C-S> <Esc>:w<CR>i
imap <C-F> <Esc>/
imap <C-Space> <C-X><C-U>
imap <C-Backspace> <C-W>
imap <C-Del> <C-[>lde

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

nnoremap <leader>w :ToggleWorkspace<CR>

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
