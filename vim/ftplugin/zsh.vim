syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"
syn match _logic_operator "&&\|||\|!"
syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"
syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"

syn match _zshfunction "^.*\((){$\)\@="

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _zshfunction ctermfg=4

inoreab <buffer>  doc #   Description:<cr><cr>Use:<esc><up>O      
inoreab <buffer>  for for in ; do<cr>done<esc>k03li
inoreab <buffer>  while while; do<cr>done<esc>k04la
inoreab <buffer>  if if [ ]; then<cr>fi<esc><Up>3<right>i

so ~/.vimrc_after
