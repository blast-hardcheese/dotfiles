augroup fugitive
  if exists('b:git_dir')
    let gitdir_path='.git'
    if filereadable(gitdir_path)
      let gitdir_path=substitute(system("cut -f2 -d ' ' < '.git'"), '\n', '/tags', 'g')
    endif

    if isdirectory(b:git_dir)
      let parenttags=b:git_dir . '/../../.tags'
      let repotags=b:git_dir . '/tags'

      if filereadable(parenttags)
        let &tags=parenttags
      else
        let &tags=repotags
      endif
    endif
  endif
augroup END
