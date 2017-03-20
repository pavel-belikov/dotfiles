" Plugins {{{
set nocompatible
if has("win32")
    let vimfiles = '$HOME/vimfiles'
else
    let vimfiles = '~/.vim'
endif

call plug#begin(vimfiles . '/bundle/')
" C++ {{{
Plug 'Valloric/YouCompleteMe'
if has("win32")
    Plug 'octol/vim-cpp-enhanced-highlight'
else
    Plug 'jeaye/color_coded'
endif
" }}}

" Project {{{
Plug 'editorconfig/editorconfig-vim'
" }}}

" UI {{{
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/TaskList.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar'
" }}}

" VCS {{{
Plug 'tpope/vim-fugitive'
" }}}

" Text editing {{{
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" }}}

" Filesystem {{{
Plug 'kien/ctrlp.vim'
Plug 'a.vim'
" }}}

" Syntax {{{
Plug 'syntaxdosini.vim'
Plug 'elzr/vim-json'
Plug 'pavel-belikov/vim-qdark'
Plug 'pavel-belikov/vim-qmake'
Plug 'pavel-belikov/vim-qtcreator-tasks'
Plug 'pprovost/vim-ps1'
" }}}

" Org {{{
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
" }}}
call plug#end()
" }}}

" GUI & OS {{{
if has("win32")
    set noshelltemp
    au GUIEnter * simalt ~x

    set guifont=Consolas:h14
    set guioptions=ait
    set showtabline=2
else
    set shell=/bin/sh

    set guifont=InconsolataLGC\ 14
    set guioptions=ait
    set showtabline=0
endif

set tags=~/.tags

set mouse=a
set sessionoptions=blank,buffers,curdir,folds,tabpages
" }}}

" Language {{{
set fileencodings=utf8,cp1251
set encoding=utf8

let $LANG='en'
set langmenu=en
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.QWERTYUIOP{}ASDFGHJKL:\\«ZXCVBNM<>
" }}}

" Vim config {{{
try
    colorscheme qdark
catch
    colorscheme desert
endtry

set wildignore=*.o,*~,*.pyc
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set laststatus=2

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent

set lazyredraw
set linebreak
set ruler
set showcmd
set wildmenu
set showmode
set number
set hls
if &diff
else
    set cursorline
endif

set noerrorbells
set visualbell
set t_vb=
set tm=500

set autoread
set noswapfile
set nobackup

set incsearch
set ignorecase

set foldenable
set foldlevel=99
set foldmethod=marker

set completeopt=
set ww=b,s,<,>,[,]
set iskeyword=@,48-57,_,192-255
set backspace=2

set scrolloff=3

set cinoptions=l0,:0

set diffopt=filler,context:1000000,vertical

filetype plugin indent on
syntax on
" }}}

" Plugins config {{{
let g:tagbar_sort=0
let g:tagbar_left=0

let g:NERDTreeWinPos='left'
let g:NERDTreeShowHidden=1

let g:ycm_confirm_extra_conf=0

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
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_theme = 'lucius'

let g:ctrlp_custom_ignore = {
    \ 'dir':  'CMakeFiles$\|\.git$\|\.hg$\|\.svn$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.PVS-Studio' }
let g:ctrlp_working_path_mode = 'a'

let g:delimitMate_expand_cr = 1

let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1

let g:cpp_experimental_template_highlight = 1

let g:workspace_autosave_untrailspaces = 0

let g:UltiSnipsExpandTrigger="<C-Space>"

let mapleader = "\<Space>"
let maplocalleader = ","
" }}}

" Key bindings {{{
nmap <A-Left> do
nmap <A-Right> dp
nmap <A-Up> [c
nmap <A-Down> ]c

nmap <Space> <nop>
nmap <Leader>q :qa<CR>
nmap <Leader>w <Leader><Leader>w
nmap <Leader>e <Leader><Leader>e
nmap <Leader>t <Plug>TaskList<CR>
nmap <Leader>u :UltiSnipsEdit<CR>
nmap <Leader>a :A<CR>
nmap <Leader>s <Leader><Leader>s
nmap <Leader>f za
nmap <Leader>g <C-]>
nmap <Leader>h :nohl<CR>
nmap <Leader>b <Leader><Leader>b
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>m :TagbarToggle<CR>

vnoremap <C-C> "+y
vnoremap <C-X> "+d
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
imap <C-Z> <Esc>ui
imap <C-Y> <Esc><C-R>i
imap <C-S> <Esc>:w<CR>i
nmap <C-S> :w!<CR>

vmap { S}
vmap ( S)
vmap [ S]
vmap " S"
vmap ' S'

nmap <F2> <C-]>
nmap <F4> :A<CR>
" }}}

" Local config {{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
" }}}

