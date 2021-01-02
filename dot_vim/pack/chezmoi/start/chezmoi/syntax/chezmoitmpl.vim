if exists("b:current_syntax") && b:current_syntax =~ '\v^%(gotexttmpl|chezmoitmpl)$'
  finish
endif

unlet! b:current_syntax

runtime! syntax/gotexttmpl.vim

unlet! b:current_syntax

syn keyword goTplControl contained define
syn keyword goTplFunctions contained slice

hi! def link goTplVariable Identifier
hi! def link goTplIdentifier Identifier

syn cluster goTplAllCluster contains=@goLiteral,goTplControl,goTplFunctions,goTplVariable,goTplIdentifier
syn cluster goTplWithoutIdCluster contains=@goLiteral,goTplControl,goTplFunctions,goTplVariable

if exists('b:chezmoi_original_filetype') && !empty(b:chezmoi_original_filetype)
  if b:chezmoi_original_filetype =~ '\v%(^|\.)%(|[bd]?a|[kcz]|tc)sh$'
    call chezmoi#syntax#addIntoCluster('shCommandSubList', 'shTestList', 'shCommentGroup')
  elseif b:chezmoi_original_filetype =~ '\v%(^|\.)vim$'
    call chezmoi#syntax#addIntoCluster('vimFuncBodyList', 'vimCommentGroup')
    call chezmoi#syntax#addIntoRegion('vimSetEqual')
  endif
endif

if exists('b:chezmoi_original_syntax')
  let b:current_syntax = b:chezmoi_original_syntax . '+chezmoitmpl'
else
  let b:current_syntax = 'chezmoitmpl'
endif

