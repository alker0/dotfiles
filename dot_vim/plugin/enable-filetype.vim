filetype plugin on

syntax on

" filename[help][modified][readonly]
set statusline=%f%h%m%r
" [fileformat option]
let &statusline .= ' %#StatusLineBlue#[%{&ff}]'
" (timestamp)
let &statusline .= ' (%{strftime("%H:%M %d/%m/%Y",getftime(expand("%:p")))})'
let &statusline .= '%#Normal#'
" right align
set statusline+=%=
" line,column N%[filetype]
let &statusline .= '%#StatusLineGreen#%l,%c %p%%%y'

" set highlight for statusline
hi StatusLineGreen term=bold ctermfg=White ctermbg=DarkGreen gui=bold guifg=White guibg=DarkGreen
hi StatusLineBlue term=bold ctermfg=Yellow ctermbg=Blue gui=bold guifg=White guibg=DarkBlue
hi StatusLineMagenta term=bold ctermfg=White ctermbg=DarkMagenta gui=bold guifg=White guibg=DarkMagenta

