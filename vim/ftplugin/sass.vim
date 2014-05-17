hi sassClass ctermfg=14

com! CompileSass exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
nnorem <buffer> <leader>cs :CompileSass<cr>
so ~/.vimrc_after
set sw=4
