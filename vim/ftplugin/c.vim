syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"
syn match _logic_operator "&&\|||\|!"
syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"
syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"
syn match _constant "\([a-zA-Z0-9]\)\@<!\u[A-Z0-9_]*[A-Z0-9]\([a-z0-9A-Z_]\)\@!"
syn match _global "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!" 

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _constant cterm=italic ctermfg=70
hi _global ctermfg=4
hi _cStruct ctermfg=6

inoreab <buffer> if if()<left><c-r>=EatSpace()<cr>
inoreab <buffer> for for(;;)<left><Left><Left><c-r>=EatSpace()<cr>
inoreab <buffer> while while()<left><c-r>=EatSpace()<cr>
inoreab <buffer> pri printf("");<left><left><left><c-r>=EatSpace()<cr>
inoreab <buffer> typd typedef ;<left><c-r>=EatSpace()<cr>
inoreab <buffer> str struct
inoreab <buffer> main int main(){<cr><cr>return EXIT_SUCCESS;<cr>}<up><up><tab>
	\<c-r>=EatSpace()<cr>
inoreab <buffer> #i #include
inoreab <buffer> #d #define

nnorem <buffer> <leader>;   $a;<esc>
nnorem <buffer> <leader>oh  :call SplitHeader("vsplit")<cr>
nnorem <buffer> <leader>oc  :call SplitSource("vsplit")<cr>
nnorem <buffer> <leader>ohs :call SplitHeader("split")<cr>
nnorem <buffer> <leader>ocs :call SplitSource("split")<cr>

func! PrintTemplate()
	echo "
		\\n#include lib
		\\n#include system
		\\n#include local
		\\n
		\\n#define function-macro
		\\n#define object-macro
		\\n
		\\nextern variables
		\\n
		\\nstruct
		\\ntypedef
		\\nstatic variables"
endfunc

source ~/.dotfiles/vimrc-after
