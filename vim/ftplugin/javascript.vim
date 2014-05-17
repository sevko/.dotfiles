syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"
syn match _logic_operator "&&\|||\|!"
syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"
syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"

syn match _javascriptFunction "\(function \)\@<=[^ \t]\+\((.*){$\)\@="
syn match _javascriptConstant
	\ "\([a-zA-Z0-9]\)\@<!\u\([A-Z0-9_]*[A-Z0-9]\)\=\([a-z0-9A-Z_]\)\@!"

syn match _javascriptLibraryPrefix "\(\W\?\)\@<=[$]"

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _javascriptFunction ctermfg=4
hi _javascriptConstant cterm=bold ctermfg=70
hi _javascriptLibraryPrefix ctermfg=1
hi javascriptFunction ctermfg=3
hi javaScriptSpecialCharacter ctermfg=1
hi javaScriptBraces ctermfg=1

inoreab <buffer>    fun     function
inoreab <buffer> if if()<left><c-r>=EatSpace()<cr>
inoreab <buffer> for for(;;)<left><Left><Left><c-r>=EatSpace()<cr>
inoreab <buffer> while while()<left><c-r>=EatSpace()<cr>

nnorem <buffer> <leader>;     $a;<esc>

so ~/.vimrc_after
