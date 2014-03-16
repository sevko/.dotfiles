syn match _graphicscript_command "^[a-zA-Z]$"
syn match _graphicscript_arguments "^.\{2,\}$"
syn match Comment "^#.*"

hi _graphicscript_command cterm=bold ctermfg=1
hi _graphicscript_arguments ctermfg=2
