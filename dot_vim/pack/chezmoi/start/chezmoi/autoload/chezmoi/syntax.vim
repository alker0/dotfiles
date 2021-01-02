function chezmoi#syntax#addIntoCluster(...) abort
  " ==== add into `cluster` ====
  " syn cluster [HERE] add=goTplAction,goTplComment
  for cl in a:000
    execute 'syn cluster ' . cl . ' add=goTplAction,goTplComment'
  endfor
endfunction

function chezmoi#syntax#addIntoRegion(...) abort
  " ==== add into `region group` ====
  " syn region goTplAction start="{{" end="}}" contains=@goTplAllCluster containedin=[HERE]
  " syn region goTplComment start="{{\(- \)\?/\*" end="\*/\( -\)\?}}" contains=@goTplAllCluster containedin=[HERE]
  let targets = a:000->join(',')
  execute 'syn region goTplAction start="{{" end="}}" contains=@goTplAllCluster containedin=' . targets
  execute 'syn region goTplComment start="{{\(- \)\?/\*" end="\*/\( -\)\?}}" contains=@goTplAllCluster containedin=' . targets

  " ==== (optional) add into `region group` (angle brackets) ====
  " syn region goTplAction start="\[\[" end="\]\]" contains=@goTplWithoutIdCluster containedin=[HERE]
  " syn region goTplComment start="\[\[\(- \)\?/\*" end="\*/\( -\)\?\]\]" contains=@goTplWithoutIdCluster containedin=[HERE]

  " execute 'syn region goTplAction start="\[\[" end="\]\]" contains=@goTplWithoutIdCluster containedin=' . targets
  " execute 'syn region goTplComment start="\[\[\(- \)\?/\*" end="\*/\( -\)\?\]\]" contains=@goTplWithoutIdCluster containedin=' . targets
endfunction

