if expand('%:t') !~# '^\%(COMMIT_EDITMSG\|MERGE_MSG\)$'
  finish
endif

if exists('*s:git_diff')
  finish
endif

if !exists('s:main_winid')
  "let s:main_bufnr = bufnr()
  let s:main_winid = win_getid()
  let s:children = {}
  augroup git_commit_main
    autocmd!
    autocmd WinClosed <buffer> call s:close_children(expand('<amatch>')) " expand('<abuf>')
    autocmd BufDelete <buffer> unlet! s:main_winid s:children
  augroup END
endif

function s:create_sticky_buf(bufname) abort
  let bufname_upper = toupper(a:bufname)
  if has_key(s:children, l:bufname_upper)
    for winid in win_findbuf(get(s:children, l:bufname_upper))
      call win_gotoid(l:winid)
      return 0
    endfor
  endif

  execute 'tabnew ' . l:bufname_upper
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nospell
  let s:children[l:bufname_upper] = bufnr()
  augroup git_commit_child
    autocmd BufDelete <buffer> call remove(s:children, expand('<afile>')) " expand('<afile>')
  augroup END
  return 1
endfunction

function s:git_diff(...) abort
  if s:create_sticky_buf('diff') == 1
    silent read !git --no-pager diff --cached --no-color
    " nextnonblank()
    " deletebufline()
    1delete
    silent! global/^index /delete
    %substitute%\v^diff +--git \zs *a/(.*) b/(\1)%a,b/\1%e
    %substitute%\v^new +file +mode +%perm: %e
    setlocal syntax=gitsendemail
    1
  endif
  if get(a:, 0, 0) == 1
    call win_gotoid(s:main_winid)
  endif
endfunction

function s:git_log(...) abort
  if s:create_sticky_buf('log') == 1
    silent read !git --no-pager log --no-color --max-count=500
    1
  endif
  if get(a:, 0, 0) == 1
    call win_gotoid(s:main_winid)
  endif
endfunction

function s:close_children(main_winid) abort " (abuf) abort
  noautocmd execute 'bdelete! ' . join(values(s:children))
  if win_getid() == a:main_winid
    quit
  endif
endfunction

"augroup git_commit_main
"  autocmd!
"  autocmd BufEnter <buffer> ++once call s:git_diff(1)
"augroup END

" How to hide ruler of `autocmd` special window ?

"setlocal laststatus=0
"setlocal cmdheight=0
"setlocal noruler
setlocal shortmess+=FatoO
setlocal noswapfile

command -bar -buffer Diff call s:git_diff()
command -bar -buffer Log call s:git_log()
"command -bar -buffer Vimdiff call s:git_vimdiff()

nnoremap <silent> <buffer> gd :Diff<CR>
nnoremap <silent> <buffer> gl :Log<CR>
"nnoremap <silent> <buffer> gD :Vimdiff<CR>
