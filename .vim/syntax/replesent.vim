" Vim syntax file
" Language: REPLesent
" Maintainer: Devon Stewart
" Latest Revision: 2016-05-17

" unlet b:current_syntax
syntax include @Scala syntax/scala.vim
syntax region replesentBlock start=/```/ end=/```/ contains=@Scala
