" Vim syntax file
" Language: AVR Assembly
" Maintainer: Devon Stewart
" Latest Revision: 28 December 2014

if exists("b:current_syntax")
  finish
endif

runtime! syntax/asm.vim syntax/asm/*.vim

fu! MatchRegister(number)
  let line='syn match R' . a:number . " '[rR]" . a:number . '\(\D\|$\)\@=' . "' display"
  exec line
endfunction

call MatchRegister('00')
call MatchRegister('01')
call MatchRegister('02')
call MatchRegister('03')
call MatchRegister('04')
call MatchRegister('05')
call MatchRegister('06')
call MatchRegister('07')
call MatchRegister('08')
call MatchRegister('09')
call MatchRegister('10')
call MatchRegister('11')
call MatchRegister('12')
call MatchRegister('13')
call MatchRegister('14')
call MatchRegister('15')
call MatchRegister('16')
call MatchRegister('17')
call MatchRegister('18')
call MatchRegister('19')
call MatchRegister('20')
call MatchRegister('21')
call MatchRegister('22')
call MatchRegister('23')
call MatchRegister('24')
call MatchRegister('25')
call MatchRegister('26')
call MatchRegister('27')
call MatchRegister('28')
call MatchRegister('29')
call MatchRegister('30')
call MatchRegister('31')
call MatchRegister('32')

fu! HighlightRegister(matchName, other, bgcolor, fgcolor)
  let line='hi def ' . a:matchName . ' ' . a:other . ' ctermbg=' . a:bgcolor . ' ctermfg=' . a:fgcolor
  exec line
endfunction

fu! HiLow(matchName, color)
  call HighlightRegister(a:matchName, 'cterm=bold', s:lowreg_bg, a:color)
endfunction

fu! HiHi(matchName, color)
  call HighlightRegister(a:matchName, 'cterm=bold', s:hireg_bg, a:color)
endfunction

let s:lowreg_bg=51
let s:hireg_bg=17

call HiLow('R00', 0)
call HiLow('R01', 57)
call HiLow('R02', 52)
call HiLow('R03', 93)
call HiLow('R04', 88)
call HiLow('R05', 124)
call HiLow('R06', 129)
call HiLow('R07', 160)
call HiLow('R08', 165)
call HiLow('R09', 196)
call HiLow('R10', 201)
call HiLow('R11', 232)
call HiLow('R12', 237)
call HiLow('R13', 9)
call HiLow('R14', 2)
call HiLow('R15', 12)
call HiHi('R16', 40)
call HiHi('R17', 45)
call HiHi('R18', 76)
call HiHi('R19', 81)
call HiHi('R20', 112)
call HiHi('R21', 117)
call HiHi('R22', 148)
call HiHi('R23', 153)
call HiHi('R24', 184)
call HiHi('R25', 189)
call HiHi('R26', 220)
call HiHi('R27', 213)
call HiHi('R28', 250)
call HiHi('R29', 255)
call HiHi('R30', 11)
call HiHi('R31', 6)
call HiHi('R32', 3)

let b:current_syntax = "symantic-avr"
