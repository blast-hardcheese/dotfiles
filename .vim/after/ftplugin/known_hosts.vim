augroup custom_detect
  au!

  autocmd BufRead ~/.ssh/known_hosts
  \ set nowrap

augroup END
