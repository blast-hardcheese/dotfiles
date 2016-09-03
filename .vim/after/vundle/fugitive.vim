augroup blast_fugitive
  function ResolveTags()
    let readlink=systemlist('which greadlink || which readlink')[0]

    if !exists('b:git_dir')
      call fugitive#detect('.')
    endif

    if exists('b:git_dir')
      let gitdir_path=b:git_dir
      if filereadable(b:git_dir . '/commondir')
        let gitdir_path=b:git_dir . '/' . readfile(b:git_dir . '/commondir')[0]
      endif
      if isdirectory(gitdir_path)
        let parenttags=gitdir_path . '/../../.tags'
        let repotags=gitdir_path . '/tags'

        if filereadable(parenttags)
          let tagfile=parenttags
        else
          let tagfile=repotags
        endif

        let &tags=systemlist(readlink . ' -f ' . shellescape(tagfile))[0]
      endif
    endif
  endfunction

  autocmd BufReadPost,FileReadPost * :call ResolveTags()
augroup END
