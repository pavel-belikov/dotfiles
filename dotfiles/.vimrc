set nocompatible

" Plugins {{{1
call plug#begin()
" C++ {{{2
Plug 'Valloric/YouCompleteMe', has('python3') && &diff ? { 'on': [] } : {}
Plug 'vim-scripts/Conque-GDB', has('python3') && executable('gdb') ? { 'on': ['ConqueGdb', 'ConqueTerm'] } : { 'on': [] }
Plug 'lyuts/vim-rtags', executable('rc') && executable('rdm') ? { 'for': ['c', 'cpp'] } : { 'on': [] }

" Project {{{2
Plug 'sgur/vim-editorconfig'
Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPMRUFiles', 'CtrlPMRUFiles', 'CtrlPTag'] }
Plug 'felikz/ctrlp-py-matcher', has('python3') ? {} : { 'on': [] }
Plug 'derekwyatt/vim-fswitch'

" Text editing {{{2
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Syntax {{{2
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'elzr/vim-json'
Plug 'pavel-belikov/vim-qdark'

" Local config {{{2
if filereadable(expand("~/.vimrc.plugins.local"))
    source ~/.vimrc.plugins.local
endif
call plug#end()

" Vim config {{{1
" GUI {{{2
if has("win32")
    set noshelltemp
    set guifont=Hack:h9
else
    set shell=/bin/sh
    set guifont=Hack\ 9
endif

augroup VimrcGuiAu
    au!
    au GUIEnter * set noerrorbells visualbell t_vb=
    if &diff
        au FilterWritePre * setlocal wrap
    endif
augroup END

set mouse=
set guioptions=ait

" UI {{{2
if $TERM == "xterm" || $TERM == "xterm-256color"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif

try
    colorscheme qdark
catch
    colorscheme desert
endtry

set autoread
set noswapfile
set nobackup
set nowritebackup

set scrolloff=5
set laststatus=0
set showtabline=1

set lazyredraw
set ttyfast

set nowrap
set linebreak

set title
set ruler
set rulerformat=%30(%=[%{empty(&fenc)?&enc:&fenc}]\ [%{&ff}]\ %l:%c\ %L%)
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

" Editing {{{2
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent
set cinoptions=l0,:0,(0

set foldenable
set foldlevel=99
set foldmethod=indent

set hlsearch
set incsearch
set ignorecase
set smartcase
if executable('ag') && !has('win32')
    set grepprg=ag\ --nogroup\ --nocolor
endif

set list
set listchars=tab:\ \ ,trail:·

set synmaxcol=250
set tags=./.tags,~/.tags
set completeopt=menu,menuone,longest,preview
set ww=b,s,<,>,[,]
set iskeyword=@,48-57,_,192-255
set backspace=2

set diffopt=filler,context:1000000,vertical

set wildignore=*.o,*.obj,*~,*.pyc,*.i,*~TMP,*.bak,*.PVS-Studio.*,*.TMP
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" FileType config {{{2
filetype plugin indent on
syntax on

augroup VimrcFileTypeConfig
    au!
    au BufEnter * syn sync minlines=1000
    au FileType c,cpp setlocal commentstring=//\ %s
    au FileType dosini,cmake,cfg setlocal commentstring=#\ %s
    au FileType qf setlocal wrap
    au FileType tasks,make setlocal noexpandtab
    au FileType conque_term,help,plug,conque_gdb setlocal nolist
    au FileType vim setlocal foldmethod=marker
    au BufNewFile,BufRead *.i set filetype=cpp
    au BufEnter *.h let b:fswitchdst='cpp,cc,C'
    au BufEnter *.cc let b:fswitchdst='h,hh,hpp'
    au BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

" Plugins config {{{1
" Netrw {{{
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

" CtrlP {{{2
let g:ctrlp_working_path_mode='a'
let g:ctrlp_clear_cache_on_exit=0
if has('python3')
    let g:ctrlp_match_func={ 'match': 'pymatcher#PyMatch' }
endif

if executable('ag') && !has('win32')
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
endif

" ConqueGDB {{{2
let g:ConqueGdb_Leader='<Leader>d'
let g:ConqueTerm_StartMessages=0
let g:ConqueGdb_SrcSplit='left'
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_CloseOnEnd=1
let g:ConqueTerm_Color=2

" EasyMotion {{{2
let g:EasyMotion_verbose=0
let g:EasyMotion_smartcase=1

" Rtags {{{2
let g:rtagsAutoLaunchRdm=1

" Key bindings {{{1
" Leader {{{2
let mapleader="\<Space>"
let maplocalleader="\\"

" Toggle Window (t) {{{2
nnoremap <silent> <leader>tl :lclose<CR>
nnoremap <silent> <leader>tq :cclose<CR>
nnoremap <silent> <leader>tp :pclose<CR>

" EasyMotion (w,s,b) {{{2
map <Leader>w <Leader><Leader>w
map <Leader>s <Leader><Leader>s
map <Leader>b <Leader><Leader>b

" Files (f) {{{2
nnoremap <silent> <Leader>ff :CtrlP<CR>
nnoremap <silent> <Leader>fr :CtrlPMRUFiles<CR>
nnoremap <silent> <Leader>fb :CtrlPBuffer<CR>
nnoremap <silent> <Leader>fa :FSHere<CR>

" Build (m) {{{2
nnoremap <silent> <Leader>mm :make!<CR>
nnoremap <silent> <Leader>mr :make! run<CR>
nnoremap <silent> <Leader>md :make!<CR>:ConqueGdb -q<CR><Esc>80<C-W>\|<C-W>p

" Debug (d) {{{2
nnoremap <silent> <Leader>dP :call conque_gdb#print_word(expand("<cWORD>"))<CR>
vnoremap <silent> <Leader>dp ygv:call conque_gdb#print_word(@")<CR>
nnoremap <silent> <Leader>dj :call conque_gdb#command("down")<CR>
nnoremap <silent> <Leader>dk :call conque_gdb#command("up")<CR>
nnoremap <silent> <Leader>dB :call conque_gdb#command("tbreak " .  expand("%:p") . ":" . line("."))<CR>
nnoremap <silent> <Leader>dJ :call conque_gdb#command("jump " .  expand("%:p") . ":" . line("."))<CR>
nmap <silent> <Leader>dm <Leader>dB<Leader>dJ
nmap <silent> <F10> <Leader>dn
nmap <silent> <F11> <Leader>ds
nmap <silent> <F12> <Leader>df

" Windows (h,j,k,l) {{{2
nnoremap <silent> <Leader>h <C-W>h
nnoremap <silent> <Leader>j <C-W>j
nnoremap <silent> <Leader>k <C-W>k
nnoremap <silent> <Leader>l <C-W>l

" Vim (v) {{{2
nnoremap <silent> <Leader>ve :e $MYVIMRC<CR>
nnoremap <silent> <Leader>vl :source $MYVIMRC<CR>

" Misc {{{2
nnoremap <silent> <Esc><Esc> :noh<CR>
vnoremap <silent> . :norm .<CR>
xnoremap <silent> @ :<C-u>echo "@" . getcmdline() \| exe ":'<,'>normal @" . nr2char(getchar())<CR>

" Local config {{{1
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vim:foldlevel=1:foldmethod=marker:
