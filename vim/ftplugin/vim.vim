Ftpackage curly_bracket

set iskeyword+=:

syn match _vimGlobal "g:\w\+" containedin=vimVar

hi vimGroupName cterm=bold
hi _vimGlobal ctermfg=5

so ~/.vimrc_after
