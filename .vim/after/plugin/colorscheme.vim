"colorscheme void
"colorscheme solarized

let g:solarized_termtrans=1
syntax enable
set background=dark
colorscheme solarized

if &diff
    colorscheme 1989
endif
" These are also good
"carvedwoodcool
"desert
"desertedocean
"desertedoceanburnt
"dull
"greens
"leo
"lettuce
"lodestone
"luinnar
"maroloccio
"molokai(
"native
"nightsky
"pf_earth
"rdark-terminal
"sift
"vj
"void
"watermark

" Start of colorscheme gallery script.
"
"     :fu! TC(name)
"     :  execute 'colorscheme '.a:name
"     :  redraw!
"     :   if input(a:name) == "k"
"     :     execute 'silent !echo "'.a:name.'" | pbcopy'
"     :   endif
"     :endfunction"
"
" Usage:
"
"     call TC('0x7A69_dark')
