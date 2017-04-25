set nocompatible

" Plugins {{{1
call plug#begin()
" C++ {{{2
Plug 'Valloric/YouCompleteMe', has('python3') && &diff ? { 'on': [] } : {}
Plug 'vim-scripts/Conque-GDB', has('python3') && executable('gdb') ? { 'on': ['ConqueGdb', 'ConqueTerm'] } : { 'on': [] }
Plug 'lyuts/vim-rtags', executable('rc') && executable('rdm') ? { 'for': ['c', 'cpp'] } : { 'on': [] }

" Project {{{2
Plug 'tpope/vim-fugitive'
Plug 'sgur/vim-editorconfig'
Plug 'kien/ctrlp.vim'
Plug 'felikz/ctrlp-py-matcher', has('python3') ? {} : { 'on': [] }
Plug 'derekwyatt/vim-fswitch'

" Text editing {{{2
Plug 'milkypostman/vim-togglelist'
Plug 'ntpeters/vim-better-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Syntax {{{2
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'elzr/vim-json'
Plug 'pavel-belikov/vim-qdark'
call plug#end()

" Vim config {{{1
" GUI {{{2
if has("win32")
    augroup VimrcWinGuiAu
        au!
        au GUIEnter * simalt ~x
    augroup END
    set noshelltemp
    set guifont=Hack:h11
else
    set shell=/bin/sh
    set guifont=Hack\ 11
endif

augroup VimrcGuiAu
    au!
    au GUIEnter * set noerrorbells visualbell t_vb=
    if &diff
        au FilterWritePre * setlocal wrap<
    endif
augroup END

set mouse=a
set guioptions=ait

" UI {{{2
if $TERM == "xterm" || $TERM == "xterm-256color"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

set fileencodings=utf8,cp1251
set encoding=utf8

let $LANG='en'
set langmenu=en

try
    colorscheme qdark
catch
    colorscheme desert
endtry

set autoread
set noswapfile
set nobackup
set nowritebackup

set scrolloff=3
set laststatus=2
set showtabline=1

set lazyredraw
set ttyfast

set nowrap
set linebreak

set title
set ruler
set wildmenu
set wildmode=longest,full
set showcmd
set showmode
set number
set nocursorline
set nocursorcolumn
set shortmess=atToOc

set switchbuf=useopen
set ttimeoutlen=50
set noerrorbells
set visualbell
set t_vb=

" Statusline {{{2
function! g:VimrcBranch()
    let branch = exists('g:loaded_fugitive') ? fugitive#head(7) : ''
    return branch != '' ? '  ' . branch . ' ' : ''
endfunction

function! g:VimrcFlags()
    let f = ''
    if &modified
        let f .= '[+]'
    endif
    if &ro || !&ma
        let f .= ''
    endif
    return f
endfunction

set statusline=%f\ %w%{g:VimrcFlags()}
set statusline+=%=
set statusline+=%{&ft}\ %{g:VimrcBranch()}
set statusline+=\ \ %l/%L\ (%c)

" Editing {{{2
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent
set cinoptions=l0,:0

set foldenable
set foldlevel=99
set foldmethod=syntax

set hlsearch
set incsearch
set ignorecase
set smartcase
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
endif

set synmaxcol=250
set tags=./.tags,~/.tags
set completeopt=menu,menuone,longest,preview
set ww=b,s,<,>,[,]
set iskeyword=@,48-57,_,192-255
set backspace=2

filetype plugin indent on
syntax on

" Diff {{{2
set diffopt=filler,context:1000000,vertical
if &diff
    augroup VimrcDiffOptions
        au!
    augroup END
endif

set wildignore=*.o,*.obj,*~,*.pyc,*.i,*~TMP,*.bak,*.PVS-Studio.*,*.TMP
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" FileType config {{{2
augroup VimrcFileTypeConfig
    au!
    au BufEnter * syn sync minlines=1000
    au FileType c,cpp let b:easytags_auto_highlight=0
                   \| setlocal commentstring=//\ %s
    au BufNewFile,BufRead *.i set filetype=cpp
    au BufEnter *.h let b:fswitchdst='cpp,cc,C'
    au FileType tasks,make setlocal noexpandtab
    au FileType org setlocal ts=2 sw=2
    au BufNewFile,BufReadPost *.md set filetype=markdown
    au FileType vim setlocal foldmethod=marker
    aut FileType qf setlocal statusline=%f%=%{&ft}\ \ \ %l/%L\ (%c)
augroup END

" Plugins config {{{1
" Netrw {{{2
let g:netrw_menu=0
let g:netrw_liststyle=2
let g:netrw_sizestyle='H'
let g:netrw_menu=0
let g:netrw_banner=0

" YouCompleteMe {{{2
let g:ycm_confirm_extra_conf=0
let g:ycm_disable_for_files_larger_than_kb=2048
let g:ycm_semantic_triggers={'haskell' : ['.']}
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1

" Rtags {{{2
let g:rtagsAutoLaunchRdm=1

" CtrlP {{{2
let g:ctrlp_working_path_mode='a'
let g:ctrlp_clear_cache_on_exit=0
if has('python3')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

function! g:VimrcCtrlpStatusLine(focus, byfname, regexp, prev, item, next, marked)
    return '%#StatusLineInsertMode# ' . a:item . ' %#StatusLineInsertModeSep#'
        \. '%* %{getcwd()}'
endfunction

let g:ctrlp_status_func = {'main': 'g:VimrcCtrlpStatusLine'}
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" EasyMotion {{{2
let g:EasyMotion_verbose=0
let g:EasyMotion_smartcase=1

" togglelist {{{2
let g:toggle_list_no_mappings = 1

" ConqueGDB {{{2
let g:ConqueGdb_Leader='<Leader>d'
let g:ConqueTerm_StartMessages=0
let g:ConqueGdb_SrcSplit='left'
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_InsertOnEnter=1

" vim-better-whitespace {{{2
let g:better_whitespace_filetypes_blacklist=['help', 'conque_term', 'vim-plug']

" Key bindings {{{1
" Leader {{{2
let mapleader="\<Space>"
let maplocalleader="\\"

" Toggle Window (t) {{{2
nnoremap <silent> <leader>tl :call ToggleLocationList()<CR>
nnoremap <silent> <leader>tq :call ToggleQuickfixList()<CR>
nnoremap <silent> <leader>tp :pclose<CR>
nnoremap <silent> <leader>tw :ToggleWhitespace<CR>

" EasyMotion (w,s,b) {{{2
nmap <Leader>w <Leader><Leader>w
omap <Leader>w <Leader><Leader>w
nmap <Leader>s <Leader><Leader>s
omap <Leader>s <Leader><Leader>s
nmap <Leader>b <Leader><Leader>b
omap <Leader>b <Leader><Leader>b

" Align (a) {{{2
nnoremap <silent> <Leader>a= :Tabularize /=<CR>
vnoremap <silent> <Leader>a= :Tabularize /=<CR>
nnoremap <silent> <Leader>a<Space> :Tabularize /\S\+<CR>
vnoremap <silent> <Leader>a<Space> :Tabularize /\S\+<CR>

" Git (g) {{{2
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gp :Gpush<CR>
nnoremap <silent> <Leader>gu :Gpull<CR>
nnoremap <silent> <Leader>gl :Glog<CR>

" Files (f) {{{2
nnoremap <silent> <Leader>fq :q<CR>
nnoremap <silent> <Leader>fw :w<CR>
nnoremap <silent> <Leader>ff :CtrlP<CR>
nnoremap <silent> <Leader>fr :CtrlPMRUFiles<CR>
nnoremap <silent> <Leader>fb :CtrlPBuffer<CR>
nnoremap <silent> <Leader>ft :CtrlPTag<CR>
nnoremap <silent> <Leader>fa :FSHere<CR>
nnoremap <silent> <Leader>fd <C-]>

" Build (m) {{{2
nnoremap <silent> <Leader>mm :make!<CR>
nnoremap <silent> <Leader>mi :make install<CR>
nnoremap <silent> <Leader>mq :QuickRun<CR>
nnoremap <silent> <Leader>mr :make run<CR>
nnoremap <silent> <Leader>md :make!<CR>:ConqueGdb -q<CR><Esc>:set syntax=conque_term<CR>60<C-W>\|<C-W>p

" Debug (d) {{{2
nnoremap <silent> <Leader>dP :call conque_gdb#print_word(expand("<cWORD>"))<CR>
vnoremap <silent> <Leader>dp ygv:call conque_gdb#print_word(@")<CR>
nnoremap <silent> <Leader>dj :call conque_gdb#command("down")<CR>
nnoremap <silent> <Leader>dk :call conque_gdb#command("up")<CR>
nnoremap <silent> <Leader>dB :call conque_gdb#command("tbreak " .  expand("%:p") . line(" "))

" YouCompleteMe (y) {{{2
nnoremap <silent> <Leader>yg :YcmCompleter GoTo
nnoremap <silent> <Leader>yf :YcmCompleter FixIt

" Windows (h,j,k,l) {{{2
nnoremap <silent> <C-H> <C-W><
nnoremap <silent> <C-J> <C-W>+
nnoremap <silent> <C-K> <C-W>-
nnoremap <silent> <C-L> <C-W>>
nnoremap <silent> <Leader>h <C-W>h
nnoremap <silent> <Leader>j <C-W>j
nnoremap <silent> <Leader>k <C-W>k
nnoremap <silent> <Leader>l <C-W>l
nnoremap <silent> <Leader>H :topleft vsplit<CR>:CtrlP<CR>
nnoremap <silent> <Leader>J :botright split<CR>:CtrlP<CR>
nnoremap <silent> <Leader>K :topleft split<CR>:CtrlP<CR>
nnoremap <silent> <Leader>L :botright vsplit<CR>:CtrlP<CR>

" Vim (v) {{{2
nnoremap <silent> <Leader>ve :e ~/.vimrc<CR>
nnoremap <silent> <Leader>vl :source ~/.vimrc<CR>
nnoremap <silent> <Leader>vu :PlugUpdate<CR>
nnoremap <silent> <Leader>vi :PlugInstall<CR>
nnoremap <silent> <Leader>vp :PlugUpgrade<CR>

" Misc {{{2
nnoremap <silent> <Esc><Esc> :noh<CR>
cnoremap <silent> <C-A> <Home>
cnoremap <silent> <C-B> <Left>
cnoremap <silent> <C-E> <End>
cnoremap <silent> <C-F> <Right>

" Local config {{{1
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vim:foldlevel=1:foldmethod=marker:

