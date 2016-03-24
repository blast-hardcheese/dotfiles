" This doesn't work, not sure why.
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['javac', 'html'] }

"                           \ 'active_filetypes': ['foo', 'bar'],

if !exists("g:syntastic_java_javac_autoload_maven_classpath")
    let g:syntastic_java_javac_autoload_maven_classpath = 1
endif

hi SpellBad term=reverse cterm=bold ctermbg=9 gui=bold guibg=Red

" From: https://github.com/derekwyatt/vim-scala/issues/107#issuecomment-104173698
let g:syntastic_ignore_files = ['\m\c\.h$', '\m\.sbt$']

" Scala has fsc and scalac checkers--running both is pretty redundant and
" slow. An explicit `:SyntasticCheck scalac` can always run the other.
let g:syntastic_scala_checkers = ['fsc']
