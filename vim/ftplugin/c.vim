Ftpackage curly_bracket

Synclude constant
syn match _arithmetic_operator '[+\-%=*]\|[*\/]\@<!\/[*\/]\@!'
syn match _delimiter "[,;]"
Synclude ternary
Synclude logic_operator
Synclude equality_operator
Synclude bitwise_operator

syn match _cAddressOperator "\(\W\@<=&[^ \t&]\@=\|\*\S\@=\|->\|\.\)"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _surrounding_element "[()[\]{}]"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t].\+ \*\=\)\@<=[^*]\+(\@="

hi _arithmetic_operator ctermfg=3
hi _bitwise_operator ctermfg=1
hi _equality_operator ctermfg=4
hi _logic_operator ctermfg=9
hi _delimiter ctermfg=242
hi _surrounding_element ctermfg=2
hi _constant cterm=bold ctermfg=70
hi _cAddressOperator ctermfg=5
hi _ternary ctermfg=1
hi _cGlobal ctermfg=1
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4
hi _cDoxygenDirective cterm=bold ctermfg=10
hi _cDoxygenReference cterm=bold ctermfg=10

com! -nargs=1 OpenTwinFile :exe printf("norm! :%s %s.%s\<cr>", <args>,
	\expand("%:p:r"), (expand("%:e") == "c")?"h":"c")

nnorem <buffer> <leader>ov :OpenTwinFile "vsplit"<cr>
nnorem <buffer> <leader>os :OpenTwinFile "split"<cr>
nnorem <buffer> <leader>gc :call <SID>GetFunctionHeaders()<cr>

func! s:PrintTemplate()
	" Echo my preferred order of declarations and definitions.

	echo join(["#include lib", "#include system", "#include local", "",
		\ "#define function-macro", "#define object-macro", "",
		\ "extern variables", "typedef", "struct", "global variables",
		\"static variables", "static function"], "\n")
endfunc

func! s:GetFunctionHeaders()
	" Paste the open header file's corresponding C file's function headers
	" below the cursor's line.

	let script = "python ~/.dotfiles/vim/scripts/c_function_headers.py"
	silent! exe printf("read! %s %s.c", l:script, expand("%:p:r"))
endfunc

source ~/.dotfiles/vimrc_after
