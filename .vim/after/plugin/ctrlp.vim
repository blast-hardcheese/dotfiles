let re_ignore='^.*[\/](dist)[\/].*$'

let localrc = getcwd() . "/.ctrlp.vim"
if filereadable(localrc)
    exec "source " . localrc
endif

if filereadable('.git')
    let &tags=&tags . ',' . substitute(system("cut -f2 -d ' ' < '.git'"), '\n', '/tags', 'g')
endif

if isdirectory('.git')
    set tags+='.git/tags'
endif

let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files --cached --exclude-standard --others'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }
let g:ctrlp_use_caching = 0

let g:ctrlp_custom_ignore = '\v(^[\/]\.(git|hg|svn)\/.*$|' . re_ignore . ')'
nnoremap <leader>. :CtrlPTag<cr>
