if exists('g:chezmoi_loaded')
  finish
endif
let g:chezmoi_loaded = 1

let s:cpoptions_save = &cpoptions
set cpoptions&vim

augroup vim_chezmoi
  autocmd!

  autocmd BufNewFile,BufRead */chezmoi/* call s:HandleChezmoiFileType()
augroup END

function! s:HandleChezmoiFileType() abort
  if did_filetype() || exists('b:chezmoi_detecting_original')
    return
  endif

  let original_abs_path = expand('<amatch>:p')

  let target_name = s:GetTargetName(original_abs_path->fnamemodify(':t'))
  let only_dot_prefix = s:GetTargetDir(original_abs_path) . '/' . target_name
  let b:chezmoi_target_path = only_dot_prefix->substitute('/\zsdot_', '.', 'g')

  if empty(target_name)
    return
  endif

  if !exists('b:detecting_original')
    let b:chezmoi_detecting_original = 1

    exe "doau filetypedetect BufRead " . b:chezmoi_target_path->fnameescape()
    unlet b:chezmoi_detecting_original

    " echo ''
    " \ . 'o_a_p: ' . original_abs_path . "\n"
    " \ . 't_n: ' . target_name . "\n"
    " \ . 't_p: ' . b:chezmoi_target_path . "\n"
    " \ . 't_p_e: ' . b:chezmoi_target_path->fnameescape() . "\n"
    " \ . 'ft_g: ' . &ft . "\n"
    " \ . 'ft_l: ' . &l:ft . "\n"
    " \ . 'detected'

    if original_abs_path =~ '\.tmpl$'
      let b:chezmoi_original_filetype = &ft

      if exists('b:current_syntax')
        let b:chezmoi_original_syntax = b:current_syntax
      endif

      setl ft+=.chezmoitmpl
    endif
  endif
endfunction

function! s:GetTargetName(original_name) abort
  return a:original_name
  \ ->substitute('\v^'
  \ . '%(\V' . getcwd()->escape('/\') . '\v)?\zs'
  \ . '%(run_)?'
  \ . '%(private_)?'
  \ . '%(empty_)?'
  \ . '%(executable_)?'
  \ . '%(symlink_)?'
  \ . '%(once_)?'
  \ . '|\.tmpl$'
  \ , '', 'g')
endfunction

function! s:GetTargetDir(original_abs_path) abort
  return a:original_abs_path
  \ ->fnamemodify(':h')
  \ ->substitute('\v'
  \ . '/\zs'
  \ . '%(exact_)?'
  \ . '%(private_)?'
  \ , '', 'g')
endfunction

let &cpoptions = s:cpoptions_save
unlet s:cpoptions_save

