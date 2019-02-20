set nocompatible

try
let g:has_python = has('python3') || has('python')
call plug#begin()
Plug 'Valloric/YouCompleteMe', g:has_python && &diff ? { 'on': [] } : {}
Plug 'vim-scripts/Conque-GDB', g:has_python && executable('gdb') ? { 'on': ['ConqueGdb', 'ConqueTerm'] } : { 'on': [] }
Plug 'sgur/vim-editorconfig'
Plug 'ctrlpvim/ctrlp.vim', { 'on': ['CtrlP', 'CtrlPMRUFiles', 'CtrlPBuffer', 'CtrlPTag'] }
Plug 'lyuts/vim-rtags', executable('rc') && executable('rdm') ? {} : { 'on': [] }
Plug 'derekwyatt/vim-fswitch'
Plug 'pavel-belikov/vim-qdark'
Plug 'rhysd/vim-clang-format', { 'on': ['ClangFormat'] }
call plug#end()
catch
endtry

if has('win32')
    set noshelltemp
    set guifont=Hack:h8
elseif has('gui_macvim')
    set shell=/bin/sh
    set guifont=Monaco:h10
else
    set shell=/bin/sh
    set guifont=Hack\ 8
endif

set mouse=a
set guioptions=ait

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
set noruler
set colorcolumn=110
set wildmenu
set wildmode=longest,full
set noshowcmd
set noshowmode
set nonumber
set nocursorline
set nocursorcolumn
set shortmess=atToOc

set switchbuf=useopen
set ttimeoutlen=50
set noerrorbells
set visualbell
set t_vb=

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set autoindent
set smartindent
set cinoptions=l0,:0,(0,Ls,g0

set nofoldenable
set foldlevel=99
set foldmethod=indent

set hlsearch
set incsearch
set ignorecase
set smartcase
if executable('ag') && !has('win32')
    set grepprg=ag\ --nogroup\ --nocolor\ --column\ --ignore-case\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

set encoding=utf8
set fileencodings=utf8,cp1251

set list
set listchars=tab:\ \ ,trail:·

set synmaxcol=250
set completeopt=menu,menuone,longest,preview

set errorformat+=%f\	%l\	%*[a-z]\	%m
set errorformat+=[ERROR]\ %f:[%l\\,%v]\ %m

set wildignore=*.o,*.obj,*~,*.pyc,*~TMP,*.bak,*.PVS-Studio.*,*.TMP
if has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

filetype plugin indent on
syntax off

augroup VimrcAuConfig
    au!
    au GUIEnter * set noerrorbells visualbell t_vb=
    au GUIEnter * syntax off
    au BufEnter * syn sync minlines=1000
    au FileType c,cpp setlocal commentstring=//\ %s
    au FileType dosini,cmake,cfg setlocal commentstring=#\ %s
    au FileType qf setlocal wrap
    au FileType tasks,make setlocal noexpandtab
    au FileType conque_term,help,plug,conque_gdb setlocal nolist
    au BufEnter *.h let b:fswitchdst='cpp,cc,C'
    au BufEnter *.cc let b:fswitchdst='h,hh,hpp'
    au BufNewFile,BufReadPost *.md set filetype=markdown
augroup END

let g:ycm_confirm_extra_conf=0
let g:ycm_disable_for_files_larger_than_kb=2048
let g:ycm_semantic_triggers={'haskell' : ['.'], 'java': ['.', '::']}
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_key_invoke_completion = '<C-U>'

let g:ctrlp_working_path_mode='a'
let g:ctrlp_clear_cache_on_exit=0

if executable('ag') && !has('win32')
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
endif

let g:ConqueGdb_Leader='<Leader>d'
let g:ConqueTerm_StartMessages=0
let g:ConqueGdb_SrcSplit='left'
let g:ConqueTerm_ReadUnfocused=1
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_CloseOnEnd=1
let g:ConqueTerm_Color=2

let g:rtagsAutoLaunchRdm=1

let mapleader="\<Space>"
let maplocalleader="\\"

map <Leader>w <Leader><Leader>w
map <Leader>s <Leader><Leader>s
map <Leader>b <Leader><Leader>b
nnoremap <silent> <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <silent> <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <silent> <Leader>gc :YcmCompleter GetDoc<CR>
nnoremap <silent> <Leader>gf :YcmCompleter FixIt<CR>
nnoremap <silent> <Leader>f :CtrlP<CR>
nnoremap <silent> <Leader>r :CtrlPBuffer<CR>
nnoremap <silent> <Leader>a :FSHere<CR>
nnoremap <silent> <Leader>m :make!<CR><CR>
nnoremap <silent> <Leader>dd :make!<CR>:ConqueGdb -q<CR><Esc>80<C-W>\|<C-W>p
nnoremap <silent> <Leader>dP :call conque_gdb#print_word(expand("<cWORD>"))<CR>
vnoremap <silent> <Leader>dp ygv:call conque_gdb#print_word(@")<CR>
nnoremap <silent> <Leader>dj :call conque_gdb#command("down")<CR>
nnoremap <silent> <Leader>dk :call conque_gdb#command("up")<CR>
nnoremap <silent> <Leader>dB :call conque_gdb#command("tbreak " .  expand("%:p") . ":" . line("."))<CR>
nnoremap <silent> <Leader>dJ :call conque_gdb#command("jump " .  expand("%:p") . ":" . line("."))<CR>
nmap     <silent> <Leader>dm <Leader>dB<Leader>dJ
nnoremap <silent> <Esc><Esc> :noh<CR>
nnoremap <silent> <Leader>c :<C-u>ClangFormat<CR>
vnoremap <silent> <Leader>c :ClangFormat<CR>

