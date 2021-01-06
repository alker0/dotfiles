filetype plugin on

syntax enable

augroup vimrc_autocmd
  autocmd BufReadPost,BufWritePost,FileWritePost,FileChangedShellPost * let b:statuslinetime = '(' . strftime("%H:%M %d/%m/%Y", getftime(expand("%:p"))) . ')'
augroup END


" filename[help][modified][readonly]
set statusline=%#StatusLineFileName#%f%h%m%r
" [fileformat option]
let &statusline .= '%#StatusLineSeparator# %#StatusLineFileInfo#[%{&ff}]'
" (timestamp)
let &statusline .= '%#StatusLineSeparator# %#StatusLineFileInfo#%{exists("b:statuslinetime") ? b:statuslinetime : ""}'
" right align
let &statusline .= '%#StatusLineSeparator#%='
" line,column N%[filetype]
let &statusline .= '%#StatusLineCursorInfo#%13(%l,%2c (%3p%%)%) %#StatusLineFileType#  %y  '

" set highlight for statusline
hi StatusLineFileName term=bold ctermfg=DarkMagenta ctermbg=LightGreen gui=bold guifg=DarkMagenta guibg=LightGreen
hi StatusLineSeparator term=bold ctermfg=NONE ctermbg=Blue gui=bold guifg=NONE guibg=Blue
hi StatusLineFileInfo term=bold ctermfg=LightGreen ctermbg=DarkBlue gui=bold guifg=LightGreen guibg=DarkBlue
hi StatusLineCursorInfo term=bold ctermfg=DarkBlue ctermbg=DarkYellow gui=bold guifg=DarkBlue guibg=DarkYellow
hi StatusLineFileType term=bold ctermfg=Yellow ctermbg=DarkMagenta gui=bold guifg=Yellow guibg=DarkMagenta

