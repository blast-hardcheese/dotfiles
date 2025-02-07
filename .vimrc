  " vimrc, accumulated over years. Largely compatible with vim and neovim.

" http://vim.wikia.com/wiki/256_colors_in_vim
" https://github.com/vim/vim/blob/2ec618c9feac4573b154510236ad8121c77d0eca/runtime/doc/syntax.txt#L5237
if (&term =~ "rxvt" || &term =~ "xterm" || &term =~ "nvim")
    if has("terminfo") || &term =~ "nvim"
        set t_Co=256
        set t_Sf=[3%p1%dm
        set t_Sb=[4%p1%dm
    else
        set t_Co=8
        set t_Sf=[3%dm
        set t_Sb=[4%dm
    endif
endif

" vim-plug
call plug#begin()

" Usability
    Plug 'junegunn/vim-easy-align'
"    Plug 'guns/xterm-color-table.vim'
"    Plug 'jreybert/vim-mark'
"    Plug 'mhinz/vim-tmuxify'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'airblade/vim-gitgutter'
    Plug 'ciaranm/detectindent'
"    Plug 'flazz/vim-colorschemes'
    Plug 'ctrlpvim/ctrlp.vim'
"    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/syntastic'
    Plug 'sjl/gundo.vim'
"    Plug 'tagbar'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-unimpaired'
    Plug 'vim-scripts/AnsiEsc.vim'
    Plug 'tpope/vim-obsession'
    Plug 'maxmx03/solarized.nvim'
    Plug 'whiteinge/diffconflicts'
    " Plug 'junegunn/vim-peekaboo'
    Plug 'hrsh7th/nvim-cmp'

" Elm
"    Plug 'ElmCast/elm-vim'

" Scala
"    Plug 'has207/vim-scala'
    Plug 'derekwyatt/vim-sbt'
    Plug 'derekwyatt/vim-scala'
"    Plug 'gre/play2vim'
    Plug 'neoclide/coc.nvim', { 'do': 'npm ci' }
"    Plug 'ensime/ensime-vim'
    Plug 'nvim-lua/plenary.nvim'  " Needed for scalameta/nvim-metals
    Plug 'scalameta/nvim-metals'  " Has a dependency on nvim-lua/plenary.nvim

" HTML/JavaScript/CSS
"    Plug 'groenewege/vim-less'
"    Plug 'othree/html5.vim'
"    Plug 'othree/javascript-libraries-syntax.vim'
"    Plug 'pangloss/vim-javascript' " Replaced with vim-jsx-improve
"    Plug 'chemzqm/vim-jsx-improve'
"    Plug 'mxw/vim-jsx'
"    Plug 'wookiehangover/jshint.vim'

" TypeScript
    Plug 'leafgarland/typescript-vim'

" Purescript
"    Plug 'raichoo/purescript-vim'
"    Plug 'frigoeu/psc-ide-vim'

" Haskell
    Plug 'lukerandall/haskellmode-vim'

" Agda
"    Plug 'derekelkins/agda-vim'

" Idris
"    Plug 'idris-hackers/idris-vim'

" SaltStack
"    Plug 'saltstack/salt-vim'

" Gitolite
"    Plug 'gitolite.vim'

" Dhall
    Plug 'vmchale/dhall-vim'

  filetype plugin indent on

call plug#end()


" Tell vim to remember certain things when we exit
"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
if ! has('nvim')
 " Neovim compat
 " https://github.com/neovim/neovim/issues/3469
 set viminfo='10,\"100,:20,%,n~/.viminfo
endif

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
set expandtab

" " Set up <tab> to insert 4 spaces
" set expandtab
" set softtabstop=4
" set shiftwidth=4
" set softtabstop=4

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

" Close tab
map <C-t>c :tabclose<cr>

" Close all other tabs
map <C-t>o :tabonly<cr>

syntax on
set ruler

" http://www.vitorrodrigues.com/blog/2006/11/24/backspace-in-vim/
set backspace=indent,eol,start

" Turn on highlighting of search results
set hlsearch

" http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
"This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

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
nnoremap <silent> tt :execute 'silent! tabmove ' . (tabpagenr()+1)<cr>
nnoremap <silent> tT :execute 'silent! tabmove ' . (tabpagenr()-2)<cr>

" Map to to "tab only"
nnoremap <silent> to :tabonly<cr>

" set ic

se incsearch

" http://vim.wikia.com/wiki/Search_across_multiple_lines
:syntax sync fromstart

" arrow keys are the devil
" allow them only for command mode to scroll the history.
" inoremap  <Up>     <NOP>
" inoremap  <Down>   <NOP>
" inoremap  <Left>   <NOP>
" inoremap  <Right>  <NOP>
" noremap   <Up>     <NOP>
" noremap   <Down>   <NOP>
" noremap   <Left>   <NOP>
" noremap   <Right>  <NOP>

" http://stackoverflow.com/questions/15277241/changing-vim-gutter-color
highlight SignColumn ctermbg=black
let g:signify_sign_color_guibg = "#ffffff"

" Disable code folding
set nofoldenable

" Create a new window, horizontally
nnoremap <C-W>n :new<cr>
" Create a new window, vertically
nnoremap <C-W>N :vnew<cr>

" http://vim.wikia.com/wiki/Editing_crontab
au BufEnter /private/tmp/crontab.* setl backupcopy=yes
au BufEnter /tmp/crontab.* setl backupcopy=yes

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

" http://vim.wikia.com/wiki/Search_and_replace_the_word_under_the_cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap <Leader>g :Ggrep -w <C-r><C-w>

" Reload settings
nnoremap <leader>R :source ~/.vimrc<CR>:echo "Reloaded ~/.vimrc"<CR>

" Reload tabs
nnoremap <leader>e :tabdo exec ':windo e'<CR>

" http://vim.wikia.com/wiki/Accessing_the_system_clipboard
set clipboard=unnamedplus

" https://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" http://vim.wikia.com/wiki/Moving_through_camel_case_words
" Use one of the following to define the camel characters.
" Stop on capital letters.
let g:camelchar = "A-Z"
" Also stop on numbers.
let g:camelchar = "A-Z0-9"
" Include '.' for class member, ',' for separator, ';' end-statement,
" and <[< bracket starts and "'` quotes.
let g:camelchar = "A-Z0-9.,;:{([`'\""
nnoremap <silent><C-Left> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
nnoremap <silent><C-Right> :<C-u>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
inoremap <silent><C-Left> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>
inoremap <silent><C-Right> <C-o>:call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>
vnoremap <silent><C-Left> :<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%^','bW')<CR>v`>o
vnoremap <silent><C-Right> <Esc>`>:<C-U>call search('\C\<\<Bar>\%(^\<Bar>[^'.g:camelchar.']\@<=\)['.g:camelchar.']\<Bar>['.g:camelchar.']\ze\%([^'.g:camelchar.']\&\>\@!\)\<Bar>\%$','W')<CR>v`<o

" Prepend both `"*` and `"+` to clipboard
" http://stackoverflow.com/a/30691754
set clipboard^=unnamed,unnamedplus

set mouse=

" Disable SQL Omni maps:
" https://www.reddit.com/r/vim/comments/2om1ib/how_to_disable_sql_dynamic_completion/
let g:omni_sql_no_default_maps = 1

" Include settings from local vimrc
let hostname = system("hostname -s")
let hostname = substitute(hostname, "\n$", "", "g")
let localrc = $HOME . "/.tools/configs/machines/" . hostname . ".vimrc"
if filereadable(localrc)
    exec "source " . localrc
endif

let localrc = $HOME . "/.tools/configs-private/machines/" . hostname . ".vimrc"
if filereadable(localrc)
    exec "source " . localrc
endif

" vim: ts=2 sts=2 sw=2
