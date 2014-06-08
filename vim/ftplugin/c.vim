Ftpackage standard
Ftpackage curly_brackets

syn match _cAddressOperator "\(\W\@<=&[^ \t&]\@=\|\*\S\@=\|->\)"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t][^ \t].\+ \*\=\)\@<=[^*]\+\((\)\@="

hi _constant cterm=bold ctermfg=70

hi _cAddressOperator ctermfg=5
hi _cGlobal ctermfg=1
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4
hi _cDoxygenDirective cterm=bold ctermfg=10
hi _cDoxygenReference cterm=bold ctermfg=10

nnorem <buffer> <leader>oh :exe "normal! :vsp " . expand("%:p:r") . ".h\<cr>"<cr>
nnorem <buffer> <leader>ohs :exe "normal! :sp " . expand("%:p:r") . ".h\<cr>"<cr>
nnorem <buffer> <leader>oc :exe "normal! :vsp " . expand("%:p:r") . ".c\<cr>"<cr>
nnorem <buffer> <leader>ocs :exe "normal! :sp " . expand("%:p:r") . ".c\<cr>"<cr>
nnorem <buffer> <leader>gc :call <SID>GetFunctionHeaders()<cr>

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
	silent! exec "read! " . script . " " . expand("%:p:r") . ".c"
endfunc

source ~/.dotfiles/vimrc_after
