Ftpackage curly_bracket

syn match _zshfunction "^.*\((){$\)\@="
syn match _zshpath "\([a-zA-Z0-9_-]\)\@<!\(\/\|\~\|$[^ \t]\+\/\)[^ \t]*"

hi _zshfunction ctermfg=14
hi _zshpath cterm=italic ctermfg=3

inoreab <buffer>  doc #   Description:<cr><cr>Use:<esc><up>O      
inoreab <buffer>  for for in ; do<cr>done<esc>k03li
inoreab <buffer>  while while; do<cr>done<esc>k04la
inoreab <buffer>  if if [ ]; then<cr>fi<esc><Up>3<right>i

so ~/.vimrc_after
