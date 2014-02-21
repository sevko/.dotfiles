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

inoreab <buffer> psvm
   \ public static void main(String[] args){<cr>}<esc>O<c-r>=EatSpace()<cr>
inoreab <buffer> if if()<left><c-r>=EatSpace()<cr>
inoreab <buffer> for for(;;)<left><Left><Left><c-r>=EatSpace()<cr>
inoreab <buffer> while while()<left><c-r>=EatSpace()<cr>
inoreab <buffer> sop System.out.println("");<left><Left><Left><c-r>=EatSpace()<cr>

nnorem <buffer>    <leader>;      $a;<esc>o

so ~/.vimrc-after
