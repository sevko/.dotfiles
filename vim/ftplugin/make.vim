syn match _arithmetic_operator "[+\-=]" containedin=makeTarget
syn match _make_prerequisites "\v(^\S*: )@<=.*" containedin=makeTarget
syn match _make_macros "$[@?^+<]" containedin=makeCommands
syn match _make_variable "\$(\w\+)"

hi makeIdent ctermfg=6
hi makeTarget ctermfg=9
hi _arithmetic_operator ctermfg=3
hi _make_prerequisites ctermfg=2
hi _make_macros ctermfg=5
hi _make_variable ctermfg=3

so ~/.vimrc_after
