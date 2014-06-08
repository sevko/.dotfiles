hi sassClass ctermfg=14

nnorem <buffer> <leader>cs :
	\exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
inorem <buffer> : : 

so ~/.vimrc_after
