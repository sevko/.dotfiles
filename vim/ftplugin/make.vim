syn match _arithmeticOperator "[+\-=]" containedin=makeTarget
syn match _makePrerequisites "\v(^\S*: )@<=.*" containedin=makeTarget
syn match _makeMacros "$[@?^+<]" containedin=makeCommands

hi makeIdent ctermfg=6
hi makeTarget ctermfg=9
hi _arithmeticOperator ctermfg=3
hi _makePrerequisites ctermfg=2
hi _makeMacros ctermfg=5

so ~/.vimrc_after
