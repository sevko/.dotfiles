setl formatoptions+=t

Ftpackage curly_bracket

Synclude constant cterm=bold ctermfg=14
syn match _arithmetic_operator '[+\-%=*]\|[*\/]\@<!\/[*\/]\@!'
syn match _delimiter "[,;]"
Synclude ternary ctermfg=1
Synclude logic_operator ctermfg=9
Synclude equality_operator ctermfg=4
Synclude bitwise_operator ctermfg=1
Synclude surrounding_element ctermfg=9

syn match _cAddressOperator "\(\W\@<=&[^ \t&]\@=\|\*\S\@=\|->\|\.\)"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9_]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t][^;]\+ \**\)\@<=[^=;(/*"]\+(\@=" contains=Comment

hi _arithmetic_operator ctermfg=3
hi _delimiter ctermfg=242

hi _cAddressOperator ctermfg=5
hi _cGlobal ctermfg=1
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4

com! -nargs=1 OpenTwinFile :silent! exe printf("norm! :%s %s.%s\<cr>", <args>,
	\expand("%:p:r"), (expand("%:e") == "c")?"h":"c")

nm <buffer> <leader>{ $a<bs>{
nnorem <buffer> <leader>ov :OpenTwinFile "vsplit"<cr>
nnorem <buffer> <leader>os :OpenTwinFile "split"<cr>
nnorem <buffer> <leader>gc :call <SID>GetFunctionHeaders()<cr>
" nnorem <buffer> m :call <SID>GetFunctionDocumentation()<cr>

func! PrintTemplate()
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

func! s:GetFunctionDocumentation()
	let func_name = expand("<cword>")
	vnew
	setl buftype=nofile bufhidden=hide noswapfile
	setl ft=man
	let manwidth_str = "MANWIDTH=" . min([winwidth(0) - 10, 78])
	echom manwidth_str
	silent! exe printf(
		\"norm! :read! " . manwidth_str . " man %s || " . manwidth_str . " man -s2 %s\<cr>gg",
		\l:func_name, l:func_name
	\)
	delete
	setl nomodifiable nobuflisted
endfunc

source ~/.dotfiles/vimrc_after
