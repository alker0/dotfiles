if exists('g:loaded_winclip')
  finish
endif
let g:loaded_winclip = 1

let s:cpo_save = &cpo
" enable line continuation
set cpo-=C
" enable special characters by backslash(\) in [] of regex
set cpo-=l
set cpo-=\

function! s:yank_to_clipboard() abort
  if v:event.regname ==# '"'
    call system('win32yank.exe -i', v:event.regcontents)
  endif
endfunction

function! s:get_clipboard_contents() abort
  return s:clipboard_contents
endfunction

function! s:paste_from_clipboard(key, mode, regtype) abort
  let contents = system('win32yank.exe -o')
  let regtype = a:regtype

  "if contents =~# '%(\n|[\x0]>)$'
  "  let regtype = 'l'
  "else
  "  let regtype = 'c'
  "endif

  let s:clipboard_contents = split(contents, '\v\r%(\n|[\x0]>)')
  if a:mode ==# 'n'
    if regtype ==# 'l'
      if a:key =~# 'p'
        call append('.', s:clipboard_contents)
      elseif a:key =~# 'P'
        call append(line('.') - 1, s:clipboard_contents)
      endif
    elseif regtype ==# 'c'
      silent execute "normal! \"=\<SID>get_clipboard_contents()\<CR>" . a:key
    endif
  elseif a:mode ==# 'v'
    silent execute "normal! gv\"=\<SID>get_clipboard_contents()\<CR>" . a:key
  endif
  unlet! s:clipboard_contents
endfunction

augroup handle_clipboard
  autocmd!
  autocmd TextYankPost * call s:yank_to_clipboard()
augroup END

nnoremap <silent> <Leader><Leader>d ""d
vnoremap <silent> <Leader><Leader>d ""d
nnoremap <silent> <Leader><Leader>y ""y
vnoremap <silent> <Leader><Leader>y ""y

"command! -range -nargs=+ PasteFromClipboard call <SID>paste_from_clipboard(<f-args>)

" Below shows E565, see https://github.com/vim-jp/issues/issues/1376
"let s:map_prefix = 'noremap <silent> <script> <expr> <Leader><Leader>'
"let s:call_suffix = "')"
let s:map_prefix = 'noremap <silent> <script> <Leader><Leader>'
let s:call_prefix = " :call \<SID>paste_from_clipboard('"
let s:call_suffix = "')\<CR>"
let s:arg_sep = "', '"
for key_prefix in ['', 'g']
  let s:key_p = key_prefix . 'p'
  let s:key_P = key_prefix . 'P'
  for [map_mode, key, arg_key, put_type] in [
  \   ['n', s:key_p, s:key_p, 'l']
  \ , ['v', s:key_p, s:key_p, 'c']
  \ , ['n', s:key_p . 'l', s:key_p, 'l']
  \ , ['n', s:key_p . 'c', s:key_p, 'c']
  \ , ['n', s:key_P, s:key_P, 'l']
  \ , ['v', s:key_P, s:key_P, 'c']
  \ , ['n', s:key_P . 'l', s:key_P, 'l']
  \ , ['n', s:key_P . 'L', s:key_P, 'l']
  \ , ['n', s:key_P . 'c', s:key_P, 'c']
  \ , ['n', s:key_P . 'C', s:key_P, 'c']
  \ ]
    execute map_mode . s:map_prefix . key . s:call_prefix . arg_key . s:arg_sep . map_mode . s:arg_sep . put_type . s:call_suffix
  endfor
endfor

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
