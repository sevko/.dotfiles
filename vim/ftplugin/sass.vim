setl iskeyword+=-

hi cssURL ctermfg=1
hi sassClass ctermfg=14

nnorem <buffer> <leader>cs :
	\exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
inorem <buffer> : : 

set sw=4
so ~/.vimrc_after
