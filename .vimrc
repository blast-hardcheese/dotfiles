" Vundle
let vundlepath=$HOME . "/.vim/bundle/vundle/.git"
if isdirectory(vundlepath) || filereadable(vundlepath)
    set nocompatible
    filetype off
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'

" Usability
    Bundle 'Lokaltog/vim-easymotion'
""    Bundle 'mhinz/vim-tmuxify'
    Bundle 'kien/ctrlp.vim'
    Bundle 'airblade/vim-gitgutter'
    Bundle "ciaranm/detectindent"
    Bundle 'scrooloose/syntastic'
    Bundle 'tagbar'

" Scala
    Bundle 'gre/play2vim'
    Bundle 'derekwyatt/vim-scala'
"    Bundle 'has207/vim-scala'
    Bundle 'derekwyatt/vim-sbt'

" HTML/JavaScript/CSS
    Bundle 'othree/html5.vim'
    Bundle "pangloss/vim-javascript"
    Bundle 'othree/javascript-libraries-syntax.vim'
    Bundle "wookiehangover/jshint.vim"
    Bundle "mxw/vim-jsx"
    Bundle "groenewege/vim-less"

" TypeScript
    Bundle "leafgarland/typescript-vim"

" Purescript
    Bundle "raichoo/purescript-vim"

" Haskell
    Bundle "lukerandall/haskellmode-vim"

" SaltStack
    Bundle "saltstack/salt-vim"

" Gitolite
    Bundle 'gitolite.vim'

    filetype plugin indent on     " required!
    "
    " Brief help
    " :BundleList          - list configured bundles
    " :BundleInstall(!)    - install(update) bundles
    " :BundleSearch(!) foo - search(or refresh cache first) for foo
    " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
    "
    " see :h vundle for more details or wiki for FAQ
    " NOTE: comments after Bundle command are not allowed..
endif


" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" when we reload, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

" Source plugin indent files (Set correct indent level per file)
filetype indent on
set indentexpr=
set noautoindent
set nocindent
set nosmartindent

" Set up <tab> to insert 4 spaces
set expandtab
set softtabstop=4
set shiftwidth=4
set softtabstop=4

"" Enable folding by indentation
"" Use: zc, zo, zC, zO, zR, zM
"" Ctrl-K .3 for ...
" set foldmethod=indent
" highlight Folded ctermfg=red
" highlight FoldColumn ctermfg=white
" set fillchars=fold:.
" set foldlevel=9999

" Map ^t + left/right to shift left and right through tabs
" Map ^t + up/down to first and last tab
" http://blogs.techrepublic.com.com/opensource/?p=678
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

syntax on
set ruler

" http://www.cs.swarthmore.edu/help/vim/
if has("spell")
  " turn spelling on by default
"  set spell

  " toggle spelling with F4 key
  map <C-F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

  " they were using white on white
  highlight PmenuSel ctermfg=black ctermbg=lightgray

  " limit it to just the top 10 items
  set sps=best,10
endif

" http://www.vitorrodrigues.com/blog/2006/11/24/backspace-in-vim/
set backspace=indent,eol,start

" Turn on highlighting of search results
set hlsearch

" http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
"This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

" Set filetypes for unknown extensions
au BufNewFile,BufRead *.wsgi set filetype=python
au BufNewFile,BufRead *.md set filetype=markdown

" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
set wrap
set linebreak
set nolist  " list disables linebreak

set textwidth=0
set wrapmargin=0

set formatoptions+=l

" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

augroup custom_detect
  au!

  autocmd BufRead ~/.ssh/known_hosts
  \ set nowrap

augroup END

" http://www.vim.org/scripts/script.php?script_id=1241
" Octave Syntax
augroup filetypedetect
     au! BufRead,BufNewFile *.m setfiletype octave
augroup END

" http://www.swaroopch.com/notes/Vim_en:Programmers_Editor
" autocmd FileType python runtime! autoload/pythoncomplete.vim
imap <c-space> <c-x><c-o>

" http://dancingpenguinsoflight.com/2009/02/python-and-vim-make-your-own-ide/
set number
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" Not sure about source
"highlight CursorColumn cterm=none ctermbg=DarkRed
"autocmd insertLeave *.py set nocursorcolumn
"autocmd insertEnter *.py set cursorcolumn

" <C-d> forward delete
" http://superuser.com/questions/153372/is-there-a-way-to-forward-delete-in-ins
"
" inoremap <C-d> <Del>

" Map tt and tT to "move tab right" and "move tab left", respectively
nnoremap <silent> tt :execute 'silent! tabmove ' . tabpagenr()<cr>
nnoremap <silent> tT :execute 'silent! tabmove ' . (tabpagenr()-2)<cr>

" set ic

se incsearch

" http://vim.wikia.com/wiki/Search_across_multiple_lines
:syntax sync fromstart

" arrow keys are the devil
" allow them only for command mode to scroll the history.
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" http://stackoverflow.com/questions/15277241/changing-vim-gutter-color
highlight SignColumn ctermbg=black
let g:signify_sign_color_guibg = "#ffffff"

" Disable code folding
set nofoldenable

" Create a new window, horizontally
nnoremap <C-W>n :new<cr>
" Create a new window, vertically
nnoremap <C-W>N :vnew<cr>

" Include settings from local vimrc
let hostname = system("hostname -s")
let hostname = substitute(hostname, "\n$", "", "g")
let localrc = $HOME . "/.tools/configs/machines/" . hostname . ".vimrc"
if filereadable(localrc)
    exec "source " . localrc
endif

let localrc = $HOME . "/.tools/configs/machines-private/" . hostname . ".vimrc"
if filereadable(localrc)
    exec "source " . localrc
endif

" Inspired by
" http://stackoverflow.com/questions/12556267/how-to-prevent-quitting-vim-accidentally
function ProtectQuit()
    cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
    echo "Quit locked"
endfunction

function UnprotectQuit()
    cunabbrev q
    echo "Quit unlocked"
endfunction

cabbrev <silent> protect call ProtectQuit()<CR>
cabbrev <silent> unprotect call UnprotectQuit()<CR>
nnoremap <silent> <Leader>p :call ProtectQuit()<CR>
nnoremap <silent> <Leader>u :call UnprotectQuit()<CR>

" https://superuser.com/questions/410982/in-vim-how-can-i-quickly-switch-between-tabs#answer-675119
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
