function! s:yank_to_clipboard() abort
  if v:event.regname ==# '"'
    call system('win32yank.exe -i', v:event.regcontents)
  endif
endfunction

function! s:paste_from_clipboard(key) abort
  let contents = system('win32yank.exe -o')
  if a:key ==# 'p'
    let contents = substitute(contents, '\v^%(\r?\n)*|%(\r?\n)*$', '', 'g')
    call append('.', contents)
  elseif a:key ==# 'P'
    let contents = substitute(contents, '\v^%(\r?\n)*|%(\r?\n)*$', '', 'g')
    call append(line('.') - 1, contents)
  endif
endfunction

augroup handle_clipboard
  autocmd!
  autocmd TextYankPost * call s:yank_to_clipboard()
augroup END

nnoremap <silent> <Leader><Leader>d ""d
vnoremap <silent> <Leader><Leader>d ""d
nnoremap <silent> <Leader><Leader>y ""y
vnoremap <silent> <Leader><Leader>y ""y
" Below shows E565, see https://github.com/vim-jp/issues/issues/1376
"nnoremap <silent> <script> <expr> <Leader><Leader>p <SID>paste_from_clipboard('p')
"vnoremap <silent> <script> <expr> <Leader><Leader>p <SID>paste_from_clipboard('p')
"nnoremap <silent> <script> <expr> <Leader><Leader>P <SID>paste_from_clipboard('P')
"vnoremap <silent> <script> <expr> <Leader><Leader>P <SID>paste_from_clipboard('P')
nnoremap <silent> <script> <Leader><Leader>p :call <SID>paste_from_clipboard('p')<CR>
vnoremap <silent> <script> <Leader><Leader>p :call <SID>paste_from_clipboard('p')<CR>
nnoremap <silent> <script> <Leader><Leader>P :call <SID>paste_from_clipboard('P')<CR>
vnoremap <silent> <script> <Leader><Leader>P :call <SID>paste_from_clipboard('P')<CR>
nnoremap <silent> <Leader><Leader>gp "=system('win32yank.exe -o')<CR>gp
vnoremap <silent> <Leader><Leader>gp "=system('win32yank.exe -o')<CR>gp
nnoremap <silent> <Leader><Leader>gP "=system('win32yank.exe -o')<CR>gP
vnoremap <silent> <Leader><Leader>gP "=system('win32yank.exe -o')<CR>gP
