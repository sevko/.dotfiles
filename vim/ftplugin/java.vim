syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"

syn match _logic_operator "&&\|||\|!"

syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"

syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"

syn match _constant "\([a-zA-Z0-9]\)\@<!\u[A-Z0-9_]*\([a-z0-9_]\)\@!"

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _constant cterm=italic ctermfg=70

so ~/.vimrc-after
