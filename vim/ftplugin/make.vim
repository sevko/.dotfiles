syn match _macro "\([a-zA-Z0-9]\)\@<!\u[A-Z0-9_]*[A-Z0-9]\([a-z0-9A-Z_]\)\@!"

hi _macro cterm=italic ctermfg=70
hi makeIdent ctermfg=6

so ~/.vimrc_after
