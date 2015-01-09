let re_ignore='^.*[\/](dist)[\/].*$'

let localrc = getcwd() . "/.ctrlp.vim"
if filereadable(localrc)
    exec "source " . localrc
endif

let g:ctrlp_custom_ignore = '\v(^[\/]\.(git|hg|svn)\/.*$|' . re_ignore . ')'
nnoremap <leader>. :CtrlPTag<cr>
