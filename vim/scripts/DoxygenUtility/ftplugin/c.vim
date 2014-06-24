syn match _cDoxygenDirective "@[a-zA-Z0-9]\+" containedin=cComment[L]\=
syn match _cDoxygenReference "::\S\+" containedin=cComment[L]\=

hi _cDoxygenDirective ctermfg=9
hi _cDoxygenReference ctermfg=9

nnoremap <silent> <leader>d
	\ :call DoxygenUtility#GenerateDoxygenComment()<cr>
