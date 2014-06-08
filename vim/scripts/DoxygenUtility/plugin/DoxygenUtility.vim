" Plugin for C source documented with Doxygen.
"
" Contains functions, syntax rules, and other constructs to help working with
" Doxygen in C source.

func! s:ConfigurePlugin()
	" Conduct any necessary plugin configuration.

	if &ft != "c"
		return
	endif

	syn match _cDoxygenDirective "@[a-zA-Z0-9]\+" containedin=cComment[L]\=
	syn match _cDoxygenReference "::\S\+" containedin=cComment[L]\=

	nnoremap <silent> <leader>d
		\ :call DoxygenUtility#GenerateDoxygenComment()<cr>
endfunc

aug DoxygenUtility
	au!
	au FileType c silent! call s:ConfigurePlugin()
aug END