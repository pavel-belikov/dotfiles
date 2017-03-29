" Plugins {{{1
set nocompatible

call plug#begin()
" C++ {{{2
Plug 'Valloric/YouCompleteMe', { 'on': [] }

if has("win32")
    Plug 'octol/vim-cpp-enhanced-highlight'
else
    Plug 'jeaye/color_coded', &diff ? { 'on': [] } : {}
    Plug 'octol/vim-cpp-enhanced-highlight', !&diff ? { 'on': [] } : {}
endif

" Python {{{2
Plug 'xolox/vim-misc', { 'for': ['sh', 'python', 'vim'] }
Plug 'xolox/vim-easytags', { 'for': ['sh', 'python', 'vim'] }
Plug 'tmhedberg/simpylfold', { 'for': 'python' }

" Project {{{2
Plug 'editorconfig/editorconfig-vim'

" UI {{{2
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-scripts/TaskList.vim', { 'on': 'TaskList' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar'

" VCS {{{2
Plug 'tpope/vim-fugitive'

" Text editing {{{2
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'michaeljsmith/vim-indent-object'
Plug 'haya14busa/incsearch.vim'

" Filesystem {{{2
Plug 'kien/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPMRUFiles'] }
Plug 'felikz/ctrlp-py-matcher'
Plug 'derekwyatt/vim-fswitch'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }

" Syntax {{{2
Plug 'syntaxdosini.vim'
Plug 'elzr/vim-json'
Plug 'pavel-belikov/vim-qdark'
Plug 'pavel-belikov/vim-qmake'
Plug 'pavel-belikov/vim-qtcreator-tasks'
Plug 'pprovost/vim-ps1'

" Org {{{2
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating', { 'for': 'org' }
call plug#end()

" Vim config {{{1
" GUI {{{2
if has("win32")
    set noshelltemp
    au GUIEnter * simalt ~x
    set guifont=Hack:h11
else
    set shell=/bin/sh
    set guifont=Hack\ 11
endif

set mouse=a
set guioptions=ait
set fileencodings=utf8,cp1251
set encoding=utf8

let $LANG='en'
set langmenu=en

" UI {{{2
try
    colorscheme qdark
catch
    colorscheme desert
endtry

set scrolloff=3
set laststatus=2
set showtabline=1
set lazyredraw
set linebreak
set ruler
set showcmd
set wildmenu
set showmode
set number
set hls
if !&diff
    set cursorline
endif

set noerrorbells
set visualbell
set t_vb=
set tm=500

" Filters {{{2
set wildignore=*.o,*~,*.pyc,*.i,*~TMP,*.bak
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Style {{{2
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent
set cinoptions=l0,:0

" Misc {{{2
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

set diffopt=filler,context:1000000,vertical
if &diff
    augroup DiffOptions
        au!
        au FilterWritePre * setlocal wrap<
    augroup END
endif

set tags=~/.tags

filetype plugin indent on
syntax on

" Plugins config {{{1
" Tagbar {{{2
let g:tagbar_sort=0
let g:tagbar_left=0

" NERDTree {{{2
let g:NERDTreeWinPos='left'
let g:NERDTreeShowHidden=1

" YouCompleteMe {{{2
let g:ycm_confirm_extra_conf=0
let g:ycm_disable_for_files_larger_than_kb=2048

" EasyTags {{{2
let g:easytags_file='~/.tags'
let g:easytags_updatetime_min=0
let g:easytags_updatetime_warn=0

" Airline {{{2
let g:airline_powerline_fonts = 1
let g:airline_section_z='[0x%02B] < %l/%L (%c)'
let g:airline#extensions#tabline#enabled=0
let g:airline#extensions#tabline#show_splits=0
let g:airline#extensions#tabline#buffer_nr_show=0
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#tab_nr_type=1
let g:airline#extensions#tabline#show_tab_nr=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#whitespace#enabled=0

let g:airline_theme='lucius'

" CtrlP {{{2
let g:ctrlp_custom_ignore={
    \ 'dir':  'CMakeFiles$\|\.git$\|\.hg$\|\.svn$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$\|\.PVS-Studio' }
let g:ctrlp_working_path_mode='a'

" delitMate {{{2
let g:delimitMate_expand_cr=1

" indent-guides {{{2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=1

" vim-workspace {{{2
let g:workspace_autosave_untrailspaces=0

" UltiSnips {{{2
let g:UltiSnipsExpandTrigger="<C-Space>"

" EasyMotion {{{2
let g:EasyMotion_verbose=0
let g:EasyMotion_smartcase=1

" vim-diffchar {{{2
let g:DiffColors=0
let g:DiffUnit="Word1"

" Ack {{{2
if executable('ag')
    let g:ackprg='ag --vimgrep'
endif

" incsearch.vim {{{2
let g:incsearch#auto_nohlsearch = 1

" Key bindings {{{1
" Leader {{{2
let mapleader="\<Space>"
let maplocalleader="\\"

" vim-better-mswin {{{2
if &diff
    nnoremap <A-Left> <C-W>ldp
    nnoremap <A-Right> <C-W>ldo
    nnoremap <A-Up> [c
    nnoremap <A-Down> ]c

    inoremap <A-Left> <C-O><C-W>l<C-O>dp
    inoremap <A-Right> <C-O><C-W>l<C-O>do
    inoremap <A-Up> <C-O>[c
    inoremap <A-Down> <C-O>]c
endif

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

nnoremap <C-A> ggvG$
inoremap <C-A> <Esc>ggvG$

nnoremap <C-Z> u
inoremap <C-Z> <C-O>u

nnoremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

nnoremap <C-Tab> gt
inoremap <C-Tab> <C-O>gt
nnoremap <C-T> :tabnew<CR>
inoremap <C-T> <C-O>:tabnew<CR>

vnoremap <C-C> "+y
vmap <C-Insert> <C-C>

vnoremap <C-X> "+d
vmap <S-Del> <C-X>

nnoremap <C-V> "+gP
exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
cnoremap <C-V> <C-R>+
nmap <S-Insert> <C-V>
imap <S-Insert> <C-V>
vmap <S-Insert> <C-V>
cmap <S-Insert> <C-V>

inoremap <C-S> <C-\><C-O>:w<CR>
nnoremap <C-S> :w!<CR>

if !&diff
    nnoremap <A-Up> :m .-2<CR>
    nnoremap <A-Down> :m .+1<CR>
    inoremap <A-Up> <Esc>:m .-2<CR>gi
    inoremap <A-Down> <Esc>:m .+1<CR>gi
    vnoremap <A-Up> :m '<-2<CR>gv
    vnoremap <A-Down> :m '>+1<CR>gv
endif

if &diff
    nnoremap <F5> :diffupdate<CR>
endif

nnoremap <F2> <C-]>
nmap <F12> <F2>

nmap <F4> :FSHere<CR>

" vim-whitespace {{{2
if !exists('g:extra_whitespace_ignored_filetypes')
    let g:extra_whitespace_ignored_filetypes = ['help']
endif

if !exists('g:whitespace_enable_by_default')
    let g:whitespace_enable_by_default = 1
endif

hi def link ExtraWhitespace ErrorMsg
hi def link whitespaceTabIndent ExtraWhitespace
hi def link whitespaceTab ExtraWhitespace
hi def link whitespaceSpaceIndent ExtraWhitespace
hi def link whitespaceTrailing ExtraWhitespace

function s:InitBuffer()
    if !exists('b:whitespace_enabled')
        let b:whitespace_enabled = g:whitespace_enable_by_default
    endif
    call s:UpdateOptions()
endfunction

function s:UpdateFileType()
    if exists('b:whitespace_enabled') && b:whitespace_enabled
        if index(g:extra_whitespace_ignored_filetypes, &ft) >= 0
            let b:whitespace_enabled = 0
            call s:UpdateOptions()
        endif
    endif
endfunction

function s:UpdateOptions()
    if !exists('b:whitespace_enabled')
        return
    endif

    if b:whitespace_enabled && &expandtab
        match whitespaceTabIndent /^\t\+/
        match whitespaceTab /[^\t]\t/
    else
        match whitespaceTabIndent //
        match whitespaceTab //
    endif

    if b:whitespace_enabled && !&expandtab
        match whitespaceSpaceIndent /^ \+/
    else
        match whitespaceSpaceIndent //
    endif

    if b:whitespace_enabled
        call s:ToggleMode('n')
    else
        match whitespaceTrailing //
    endif
endfunction

function s:ToggleMode(mode)
    if !exists('b:whitespace_enabled') || !b:whitespace_enabled
        return
    endif

    if a:mode == 'i'
        match whitespaceTrailing /\s\+\%#\@<!$/
    else
        match whitespaceTrailing /\s\+$/
    endif
endfunction

augroup VimWhitespace
    au!
    au BufRead,BufNew * call s:InitBuffer()
    au FileType * call s:UpdateFileType()
    au OptionSet * call s:UpdateOptions()
    au InsertLeave * call s:ToggleMode('n')
    au InsertEnter * call s:ToggleMode('i')
augroup END

" Toggle Window (t) {{{2
nmap <Leader>tq :q<CR>
nmap <Leader>tt :TaskList<CR>
nmap <Leader>tn :NERDTreeToggle<CR>
nmap <Leader>tb :TagbarToggle<CR>

" EasyMotion (w,s,b) {{{2
nmap <Leader>w <Leader><Leader>w
omap <Leader>w <Leader><Leader>w
nmap <Leader>s <Leader><Leader>s
omap <Leader>s <Leader><Leader>s
nmap <Leader>b <Leader><Leader>b
omap <Leader>b <Leader><Leader>b

" VCS (g) {{{2
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gc :Gcommit<CR>
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gp :Gpush<CR>
nmap <Leader>gu :Gpull<CR>
nmap <Leader>gl :Glog<CR>

" Files (f) {{{2
nmap <Leader>ff :CtrlP<CR>
nmap <Leader>fw :w<CR>
nmap <Leader>fr :CtrlPMRUFiles<CR>
nmap <Leader>fa :FSHere<CR>
nmap <Leader>fd <C-]>

" Build (m) {{{2
nmap <Leader>m :make<CR>

" Windows {{{2
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
nmap <C-H> <C-W>h

" Surround {{{2
vmap { S}
vmap ( S)
vmap [ S]
vmap " S"
vmap ' S'

" incsearch.vim {{{2
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)



" FileType config {{{2
augroup FileTypeConfig
    au!
    au FileType c,cpp let b:easytags_auto_highlight = 0
                   \| setlocal commentstring=//\ %s
    au BufNewFile,BufRead *.i set filetype=cpp
    au FileType org setlocal ts=2 sw=2
augroup END

if !&diff
    augroup LoadInsertPlugins
        au!
        au InsertEnter * call plug#load('YouCompleteMe')
                    \| au! LoadInsertPlugins
    augroup END
endif


" Local config {{{1
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vim:foldlevel=1:

