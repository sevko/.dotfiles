hi sassClass ctermfg=14

com! exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
nnorem <buffer> <leader>cs :CompileSass<cr>
so ~/.vimrc_after
