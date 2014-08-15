colorscheme dark

set nocompatible
set shell=/bin/sh

if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

set exrc
set secure

set tags=~/.tags

set mouse=a
set sessionoptions=blank,buffers,curdir,folds,tabpages

set fileencodings=utf8
set encoding=utf8

set guifont=Inconsolata\ 14
set guioptions=ai
set showtabline=0

set laststatus=2
set statusline=%!MyStatusLine()
set tabline=%!MyTabLine()

set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set autoindent
set smartindent
let &cc=join(range(81,999),",")

autocmd BufReadPost,FileReadPost,BufNewFile,BufWinEnter * call system("tmux rename-window 'vim " . expand("%") . "'")
autocmd VimLeave * call system("tmux rename-window bash")

set iskeyword=@,48-57,_,192-255

filetype plugin indent on
syntax on
autocmd BufWinEnter * match ErrorMsg /\s\+$/
autocmd BufWinLeave * call clearmatches()

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
let g:ycm_global_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<Down>']

let g:easytags_file='~/.tags'
let g:easytags_updatetime_min=0
let g:easytags_updatetime_warn=0

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
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left><CR><CR><Up><Tab>
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

autocmd VimEnter * nested :call LoadSession()
autocmd VimLeave * :call MakeSession()

" git branch
function MyStatusLine()
    let s = ""
    let m = mode()
    let t = ""
    if m == 'i'
        let t = 'Insert'
        let m = 'Insert'
    elseif m == 'R'
        let t = 'Replace'
        let m = 'Insert'
    elseif m == 'Rv'
        let t = 'Virtual Replace'
        let m = 'Virtual'
    elseif m == 'v' || m == 'V'|| m == 'CTRL-V' || m == 's' || m == 'S' || m == 'CTRL-S'
        let t = 'Visual'
        let m = 'Visual'
    elseif m == 'c'
        let t = 'Command'
        let m = 'Normal'
    else
        let t = 'Normal'
        let m = 'Normal'
    endif
    let s .= '%#StatusLine' . m . 'Mode# ' . t . ' '
    let s .= '%##| %f %m%r%h%w %y | %{strlen(&fenc) ? &fenc : &enc} | %{&ff}%=%{tagbar#currenttag("%s | ","")}(ch:%b 0x%B) | %c : %l/%L [%p%%]'
    let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    if branch != ''
        let s .= ' |%#StatusLineInsertMode# ' . substitute(branch, '\n', '', 'g') . ' '
    endif
    return s
endfunction

function MyTabLine()
    let s = ''
	for i in range(tabpagenr('$'))
        if i != 0
            let s .= '%#TabLine#%T|'
        endif
        if i + 1 == tabpagenr()
	        let s .= '%#TabLineSel#'
	    else
	        let s .= '%#TabLine#'
	    endif
        let s .= '%' . (i + 1) . 'T [' . (i + 1) . ']'
        let n = ''
        for b in tabpagebuflist(i + 1)
            let n .= ' '
            if getbufvar(b, "&buftype") == 'help'
                let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
            elseif getbufvar(b, "&buftype") == 'quickfix'
                let n .= '[Q]'
            else
                let n .= fnamemodify(bufname(b), ':p:t')
            endif

            if getbufvar(b, "&modified")
                let n .= '*'
            endif
        endfor
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        if n == ''
            let s .= '[New]'
        else
            let s .= n
        endif
        let s .= ' '
    endfor
    if tabpagenr('$') >= 0
        let s .= '%#TabLine#|'
    endif
    let s .= '%#TabLineFill#%T'
    if tabpagenr('$') > 1
	    let s .= '%=%999XX'
    endif
    return s
endfunction

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
