syn match _arithmetic_operator "+\|-\|\*\|%\|<\|>\|="
syn match _arithmetic_operator "\(/\|*\)\@<!/\(/\|*\)\@!"
syn match _logic_operator "&&\|||\|!"
syn match _bitwise_operator "\(&\)\@<!&\(&\)\@!"
syn match _bitwise_operator "\(|\)\@<!|\(|\)\@!"
syn match _bitwise_operator "<<\|>>\|\^"
syn match _surrounding_element "(\|)\|\[\|\]\|{\|}"
syn match _delimiters "\.\|,\|:"
syn match _end_of_line ";"
syn match _cConstant
	\ "\([a-zA-Z0-9]\)\@<!\u\([A-Z0-9_]*[A-Z0-9]\)\=\([a-z0-9A-Z_]\)\@!"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t][^ \t].\+ \)\@<=[^ \t]\+\((\)\@="
syn match _cDoxygenDirective "@[a-zA-Z0-9]\+" containedin=cComment[L]\=
syn match _cDoxygenReference "::[a-zA-Z0-9_]\+" containedin=cComment[L]\=

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _cConstant cterm=bold ctermfg=70
hi _global ctermfg=4
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4
hi _cDoxygenDirective cterm=bold ctermfg=10
hi _cDoxygenReference cterm=bold ctermfg=10

nnorem <buffer> <leader>;   $a;<esc>
nnorem <buffer> <leader>oh  :call SplitHeader("vsplit")<cr>
nnorem <buffer> <leader>oc  :call SplitSource("vsplit")<cr>
nnorem <buffer> <leader>ohs :call SplitHeader("split")<cr>
nnorem <buffer> <leader>ocs :call SplitSource("split")<cr>
nnorem <buffer> <leader>gc  :call GetHeaders()<cr>
nnorem <buffer> <leader>d   :call DoxygenComment()<cr>

" print my preferred order of declaration statement
func! PrintTemplate()
	echom "
		\\n#include lib
		\\n#include system
		\\n#include local
		\\n
		\\n#define function-macro
		\\n#define object-macro
		\\n
		\\nextern variables
		\\n
		\\nstatic function
		\\nstatic variables
		\\nstruct
		\\ntypedef"
endfunc

func! GetHeaders()
	let script = "python ~/.dotfiles/vim/scripts/c_function_headers.py"
	silent! exec "read! " . script . " " . expand("%:p:r") . ".c"
endfunc

func! DoxygenComment()
	let script = "python ~/.dotfiles/vim/scripts/c_doxygen_comment.py"
	silent! exec "normal! 0\"ay/\\()[;{]\\)\\@<=$\<cr>"
	let func_string = substitute(@a, "\\n", " ", "g")
	exec (line(".") - 1) . "r! echo '" . func_string . "' | " . script
endfunc

source ~/.dotfiles/vimrc_after
