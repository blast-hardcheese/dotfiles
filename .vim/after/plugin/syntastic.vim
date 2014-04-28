" This doesn't work, not sure why.
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'passive_filetypes': ['javac'] }

"                           \ 'active_filetypes': ['foo', 'bar'],

if !exists("g:syntastic_java_javac_autoload_maven_classpath")
    let g:syntastic_java_javac_autoload_maven_classpath = 1
endif
