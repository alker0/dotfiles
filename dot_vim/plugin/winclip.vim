function! s:yankToClipboard()
  if v:event.regname ==# '"'
    call system('win32yank.exe -i', v:event.regcontents)
  endif
endfunction

augroup handle_clipboard
  autocmd!
  autocmd TextYankPost * call s:yankToClipboard()
augroup END

nnoremap <silent> <Leader><Leader>d ""d
vnoremap <silent> <Leader><Leader>d ""d
nnoremap <silent> <Leader><Leader>y ""y
vnoremap <silent> <Leader><Leader>y ""y
nnoremap <silent> <Leader><Leader>p "=system('win32yank.exe -o')<CR>p
vnoremap <silent> <Leader><Leader>p "=system('win32yank.exe -o')<CR>p
