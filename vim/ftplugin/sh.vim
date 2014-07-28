set iskeyword+=$
set formatoptions+=or
Ftpackage curly_bracket

Synclude shell_script_path ctermfg=6

syn match _shfunction "^.*\((){$\)\@="

hi _shfunction ctermfg=4

inoreab <buffer>  for for in ; do<cr>done<esc>k03li
inoreab <buffer>  while while; do<cr>done<esc>k04la
inoreab <buffer>  if if [ ]; then<cr>fi<esc><Up>3<right>i

so ~/.vimrc_after
