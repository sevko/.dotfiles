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
	\ "\w\@<!\u\([A-Z0-9_]*[A-Z0-9]\)\=\w\@!"
syn match _cAddressOperator "\(\W\@<=&[^ \t&]\@=\|\*\S\@=\)"
syn match _cGlobal "\([a-zA-Z0-9]\)\@<!g_[a-zA-Z0-9]\+\([a-zA-Z0-9]\)\@!"
syn match _cStruct "\([a-zA-Z0-9]\)[a-zA-Z0-9]\+_t\([a-zA-Z0-9]\)\@!"
syn match _cFunction "\(^[^# \t][^ \t].\+ \*\=\)\@<=[^*]\+\((\)\@="

hi _arithmetic_operator ctermfg=3
hi _logic_operator ctermfg=2
hi _bitwise_operator ctermfg=1
hi _surrounding_element ctermfg=2
hi _delimiters ctermfg=166
hi _end_of_line ctermfg=244
hi _cAddressOperator ctermfg=5
hi _cConstant cterm=bold ctermfg=70
hi _cGlobal ctermfg=1
hi _cStruct ctermfg=6
hi _cFunction ctermfg=4
hi _cDoxygenDirective cterm=bold ctermfg=10
hi _cDoxygenReference cterm=bold ctermfg=10

com! OpenHeaderVSplit exe "normal! :vsp " . expand("%:p:r") . ".h\<cr>"
com! OpenHeaderSplit exe "normal! :sp " . expand("%:p:r") . ".h\<cr>"
com! OpenSourceVSplit exe "normal! :vsp " . expand("%:p:r") . ".c\<cr>"
com! OpenSourceSplit exe "normal! :sp " . expand("%:p:r") . ".c\<cr>"

nnorem <buffer> <leader>;
	\ :exe "norm! $" . (getline(".")[-1:] == "{"?"r":"a") . ";"<cr>
nnorem <buffer> <leader>oh :OpenHeaderVSplit<cr>
nnorem <buffer> <leader>ohs :OpenHeaderSplit<cr>
nnorem <buffer> <leader>oc :OpenSourceVSplit<cr>
nnorem <buffer> <leader>ocs :OpenSourceSplit<cr>
nnorem <buffer> <leader>gc :call <SID>GetFunctionHeaders()<cr>
nnorem { :call <SID>InsertBraces()<cr>
nnorem } :call <SID>DeleteBraces()<cr>

" print my preferred order of declaration statement
func! PrintTemplate()
	echo join(["#include lib", "#include system", "#include local", "",
		\ "#define function-macro", "#define object-macro", "",
		\ "extern variables", "typedef", "struct", "static variables",
		\ "static function"], "\n")
	endfunc

func! GetHeaders()
	let script = "python ~/.dotfiles/vim/scripts/c_function_headers.py"
	silent! exec "read! " . script . " " . expand("%:p:r") . ".c"
endfunc

func! s:DeleteBraces()
	" Delete the braces encapsulating the block of code under the cursor.

	let orig_cur_pos = [line("."), col(".")]

	call searchpair("{", "", "}")
	exe "norm! dd"
	call searchpair("{", "", "}", "b")
	exe "norm! x"

	call cursor(l:orig_cur_pos)
endfunc

func! s:InsertBraces()
	" Insert braces around the block of code under the cursor.

	let orig_cur_pos = [line("."), col(".")]

	let indent_lvl = len(matchstr(getline("."), "^\t*"))
	let search_patt_fmt = printf('^%s\{0,%%d\}\(\S.*\)\=[^{]$', "\t")
	if cursor(searchpos(printf(l:search_patt_fmt, l:indent_lvl - 1), "b")) != -1
		exe "norm! $a{"
	endif

	if cursor(searchpos(printf(l:search_patt_fmt, l:indent_lvl - 1))) != -1 &&
		\cursor(searchpos(printf(l:search_patt_fmt, l:indent_lvl), "b")) != -1
		exe "norm! o}"
	endif

	call cursor(l:orig_cur_pos)
endfunc

func! s:GetFunctionHeaders()
	" Paste the open header file's corresponding C file's function headers
	" below the cursor's line.

	let script = "python ~/.dotfiles/vim/scripts/c_function_headers.py"
	silent! exec "read! " . script . " " . expand("%:p:r") . ".c"
endfunc

source ~/.dotfiles/vimrc_after
