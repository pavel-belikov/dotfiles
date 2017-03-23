" Plugins {{{
set nocompatible
if has("win32")
    let vimfiles='$HOME/vimfiles'
else
    let vimfiles='~/.vim'
endif

call plug#begin(vimfiles . '/bundle/')
" C++ {{{
if &diff
else
    Plug 'Valloric/YouCompleteMe'
endif

if has("win32") || &diff
    Plug 'octol/vim-cpp-enhanced-highlight'
else
    Plug 'jeaye/color_coded'
endif
" }}}

" Project {{{
Plug 'editorconfig/editorconfig-vim'
" }}}

" UI {{{
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
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
Plug 'derekwyatt/vim-fswitch'
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
Plug 'tpope/vim-speeddating', { 'for': 'org' }
" }}}
call plug#end()
" }}}

" Vim config {{{

" Language {{{
set fileencodings=utf8,cp1251
set encoding=utf8

let $LANG='en'
set langmenu=en
set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.QWERTYUIOP{}ASDFGHJKL:\\«ZXCVBNM<>
" }}}

" GUI {{{
if has("win32")
    set noshelltemp
    au GUIEnter * simalt ~x
    set guifont=Consolas:h14
else
    set shell=/bin/sh
    set guifont=InconsolataLGC\ 14
endif

set mouse=a
set guioptions=ait
" }}}

try
    colorscheme qdark
catch
    colorscheme desert
endtry

set wildignore=*.o,*~,*.pyc,*.i,*~TMP,*.bak
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set laststatus=2
set showtabline=0

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
set foldlevel=1
set foldmethod=marker

set completeopt=
set ww=b,s,<,>,[,]
set iskeyword=@,48-57,_,192-255
set backspace=2

set scrolloff=3

set cinoptions=l0,:0

set diffopt=filler,context:1000000,vertical

set tags=~/.tags

filetype plugin indent on
syntax on

au FileType c,cpp setlocal commentstring=//\ %s
" }}}

" Plugins config {{{
let g:tagbar_sort=0
let g:tagbar_left=0

let g:NERDTreeWinPos='left'
let g:NERDTreeShowHidden=1

let g:ycm_confirm_extra_conf=0
let g:ycm_disable_for_files_larger_than_kb=2048

let g:easytags_file='~/.tags'
let g:easytags_updatetime_min=0
let g:easytags_updatetime_warn=0

if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif

let g:airline_section_z='[0x%02B] < %l/%L (%c)'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_splits=0
let g:airline#extensions#tabline#buffer_nr_show=0
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#tab_nr_type=1
let g:airline#extensions#tabline#show_tab_nr=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#whitespace#enabled = 1

let g:airline_theme='lucius'

let g:ctrlp_custom_ignore={
    \ 'dir':  'CMakeFiles$\|\.git$\|\.hg$\|\.svn$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.PVS-Studio' }
let g:ctrlp_working_path_mode='a'

let g:delimitMate_expand_cr=1

let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=1

let g:cpp_experimental_template_highlight=1

let g:workspace_autosave_untrailspaces=0

let g:UltiSnipsExpandTrigger="<C-Space>"

let g:EasyMotion_verbose = 0

let mapleader="\<Space>"
let maplocalleader=","
" }}}

" Key bindings {{{
" vim-better-mswin {{{
nnoremap <A-Left> do
nnoremap <A-Right> dp
nnoremap <A-Up> [c
nnoremap <A-Down> ]c

inoremap <A-Left> <C-O>do
inoremap <A-Right> <C-O>dp
inoremap <A-Up> <C-O>[c
inoremap <A-Down> <C-O>]c

nnoremap <C-Left> b
vnoremap <C-Left> b
inoremap <C-Left> <Left><C-\><C-O>b

nnoremap <C-Right> e
vnoremap <C-Right> e
inoremap <C-Right> <C-\><C-O>e<Right>

nnoremap <C-S-Left> vb
vnoremap <C-S-Left> b
inoremap <C-S-Left> <Left><C-\><C-O>vb

nnoremap <C-S-Right> ve
inoremap <C-S-Right> <C-\><C-O>ve
vnoremap <C-S-Right> e

noremap <C-A> ggvG
inoremap <C-A> <Esc>ggvG

noremap <C-Z> u
inoremap <C-Z> <C-O>u

noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w

noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c

vnoremap <C-C> "+y
vmap <C-Insert> <C-C>

vnoremap <C-X> "+d
vmap <S-Del> <C-X>

noremap <C-T> :tabnew<Space>

noremap <C-V> "+gP
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
map <S-Insert> <C-V>
imap <S-Insert> <C-V>
vmap <S-Insert> <C-V>

inoremap <C-S> <C-\><C-O>:w<CR>
nnoremap <C-S> :w!<CR>
" }}}

" vim-whitespace {{{

function s:MatchWhitespace()
    let l:pattern = '\s\+$'
    if &expandtab
        let l:pattern .= '\|\t\+'
    endif
    let g:deb_p = l:pattern
    exe 'match ExtraWhitespace /' . l:pattern . '/'
endfunction

autocmd BufRead,BufNew * call s:MatchWhitespace()
autocmd InsertLeave * call s:MatchWhitespace()
autocmd InsertEnter * call s:MatchWhitespace()

" }}}

function! NumberToggle()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

nmap <Space> <nop>
nmap <Leader>q :qa<CR>
nmap <Leader>w <Leader><Leader>w
nmap <Leader>e <Leader><Leader>e
nmap <Leader>r :call NumberToggle()<CR>
nmap <Leader>t <Plug>TaskList<CR>
nmap <Leader>u :UltiSnipsEdit<CR>
nmap <Leader>i :nohl<CR>
nmap <Leader>o :w!<CR>
nmap <Leader>a :FSHere<CR>
nmap <Leader>s <Leader><Leader>s
nmap <Leader>f za
nmap <Leader>g <C-]>
nmap <Leader>b <Leader><Leader>b
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>m :TagbarToggle<CR>

nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
nmap <C-H> <C-W>h

vmap { S}
vmap ( S)
vmap [ S]
vmap " S"
vmap ' S'
" }}}

" Local config {{{
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
" }}}

