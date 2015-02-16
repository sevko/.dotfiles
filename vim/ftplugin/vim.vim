Ftpackage curly_bracket

set iskeyword+=:
let g:vim_indent_cont=shiftwidth()

Synclude ternary containedin=ALL ctermfg=5
syn match _vimAutoloadSymbol "\v\w@<=#\w@=" containedin=ALL
syn match _vimGlobal "g:\w\+" containedin=vimVar,vimOperParen
syn match _vimFunctionName "\v(func!= )@<=\k+" containedin=vimFunction

hi _vimAutoloadSymbol ctermfg=5
hi _vimGlobal ctermfg=5
hi _vimFunctionName ctermfg=14
hi vimGroupName cterm=bold

so ~/.vimrc_after
