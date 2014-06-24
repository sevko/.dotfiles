syn match _templateFlag "__[A-Z0-9_]\+__" containedin=ALL

hi _templateFlag cterm=italic ctermfg=70

source ~/.dotfiles/vimrc_after
