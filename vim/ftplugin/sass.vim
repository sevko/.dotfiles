hi sassClass ctermfg=14

com! CompileSass exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
nnorem <buffer> <leader>cs :CompileSass<cr>
set sw=4
so ~/.vimrc_after
