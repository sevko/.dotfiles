setl iskeyword+=@-@,$,#,.,-

hi cssURL ctermfg=1
hi sassClass ctermfg=14

nnorem <buffer> <leader>cs :
	\exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
inorem <buffer> : <c-r>=getline(".")[col(".") - 2] == "&"?":":": "<cr>

so ~/.vimrc_after
set noet sw=4
