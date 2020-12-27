augroup chezmoi
  au!
  " if &ft != 'template' |  | endif

  " Git
  au BufNewFile,BufRead *.git/{empty_,executable_}config,{,empty_,executable_}dot_gitconfig,*/etc/{empty_,executable_}gitconfig setf gitconfig
  au BufNewFile,BufRead */.config/git/{empty_,executable_}config setf gitconfig

  " Group file
  au BufNewFile,BufRead */etc/{empty_,executable_}{group,group-,gshadow,gshadow-} setf group

  " Man config
  au BufNewFile,BufRead */etc/{empty_,executable_}man.conf,{empty_,executable_}man.config setf manconf

  " NPM RC file
  au BufNewFile,BufRead {,empty_,executable_}dot_npmrc,{empty_,executable_}npmrc setf dosini

  " Readline
  au BufNewFile,BufRead {,empty_,executable_}dot_inputrc,{empty_,executable_}inputrc setf readline

  " Interactive Ruby shell
  au BufNewFile,BufRead {,empty_,executable_}dot_irbrc,{empty_,executable_}irbrc setf ruby

  " Bundler
  au BufNewFile,BufRead {empty_,executable_}Gemfile setf ruby

  " Vim script
  au BufNewFile,BufRead {,empty_,executable_}dot_exrc,{empty,executable_}_exrc setf vim
  " Viminfo file
  au BufNewFile,BufRead {,empty_,executable_}dot_viminfo,{empty_,executable_}_viminfo setf viminfo

  " Wget config
  au BufNewFile,BufRead {,empty_,executable_}dot_wgetrc,{empty_,executable_}wgetrc setf wget

  " Git
  au BufNewFile,BufRead */{,dot_}gitconfig.d/* if &ft != 'template' | call s:StarSetf('gitconfig') | endif

  " Shell scripts ending in a star
  au BufNewFile,BufRead {,empty_,executable_}dot_bashrc*,{,empty_,executable_}dot_bash[_-]profile*,{,empty_,executable_}dot_bash[_-]logout*,{,empty_,executable_}dot_bash[_-]aliases*,{empty_,executable_}{PKGBUILD,APKBUILD}*,*/{,dot_}bash[_-]completion{,.d}/* if &ft != 'template' | call dist#ft#SetFileTypeSH("bash") | endif
  au BufNewFile,BufRead {,empty_,executable_}dot_kshrc* if &ft != 'template' | call dist#ft#SetFileTypeSH("ksh") | endif 
  au BufNewFile,BufRead {,empty_,executable_}dot_profile*,profile.d/* if &ft != 'template' | call dist#ft#SetFileTypeSH(getline(1)) | endif

  " tcsh scripts ending in a star
  au BufNewFile,BufRead {,empty_,executable_}dot_tcshrc* if &ft != 'template' | call dist#ft#SetFileTypeShell("tcsh") | endif

  " csh scripts ending in a star
  au BufNewFile,BufRead {,empty_,executable_}dot_{login,cshrc}* if &ft != 'template' | call dist#ft#CSH() | endif

  " Vim script
  au BufNewFile,BufRead *vimrc* if &ft != 'template' | call s:StarSetf('vim') | endif

  " Z-Shell script ending in a star
  au BufNewFile,BufRead {,empty_,executable_}dot_{zsh,zlog,zcompdump}* if &ft != 'template' | call s:StarSetf('zsh') | endif
  au BufNewFile,BufRead {empty_,executable_}{zsh,zlog}* if &ft != 'template' | call s:StarSetf('zsh') | endif


  " Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
  " Gentoo ebuilds, Arch Linux PKGBUILDs and Alpine Linux APKBUILDs are actually
  " bash scripts.
  " NOTE: Patterns ending in a star are further down, these have lower priority.
  au BufNewFile,BufRead {,empty_,executable_}dot_{bashrc},bash.bashrc,{,empty_,executable_}dot_bash[_-]profile,{,empty_,executable_}dot_bash[_-]logout,{,empty_,executable_}dot_bash[_-]aliases,*/{,empty_,executable_}{,dot_}bash[_-]completion{,.sh},{empty_,executable_}{PKGBUILD,APKBUILD} call dist#ft#SetFileTypeSH("bash")
  au BufNewFile,BufRead {,empty_,executable_}dot_kshrc call dist#ft#SetFileTypeSH("ksh")
  au BufNewFile,BufRead */etc/{empty_,executable_}profile,{,empty_,executable_}dot_profile call dist#ft#SetFileTypeSH(getline(1))

  " tcsh scripts (patterns ending in a star further below)
  au BufNewFile,BufRead {,empty_,executable_}dot_tcshrc,{empty_,executable_}tcsh{.tcshrc,.login} call dist#ft#SetFileTypeShell("tcsh")

  " csh scripts, but might also be tcsh scripts (on some systems csh is tcsh)
  " (patterns ending in a start further below)
  au BufNewFile,BufRead {,empty_,executable_}dot_{login,cshrc,alias},{empty_,executable_}{csh.cshrc,csh.login,csh.logout} call dist#ft#CSH()

  " Z-Shell script (patterns ending in a star further below)
  au BufNewFile,BufRead {,empty_,executable_}dot_{zprofile,zfbfmarks},*/etc/{empty_,executable_}zprofile setf zsh
  au BufNewFile,BufRead {,empty_,executable_}dot_{zshrc,zshenv,zlogin,zlogout,zcompdump} setf zsh

  " Function used for patterns that end in a star: don't set the filetype if the
  " file name matches ft_ignore_pat.
  " When using this, the entry should probably be further down below with the
  " other StarSetf() calls.
  func! s:StarSetf(ft)
    if expand("<amatch>") !~ g:ft_ignore_pat
      exe 'setf ' . a:ft
    endif
  endfunc
  
  let gotpl_path=$HOME . '/.vim/syntax/gotpl.vim'
  au BufNewFile,BufRead *.tmpl if filereadable(gotpl_path) | exec 'source ' . gotpl_path | endif

augroup end

