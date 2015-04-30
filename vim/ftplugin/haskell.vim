set iskeyword+='

inorem ' <c-r>=SmartSingleQuote()<cr>
func! SmartSingleQuote()
	let isInIdentifier = getline(".")[getcurpos()[2] - 2] =~ '\k'
	return isInIdentifier ? "'" : "''\<left>"
endfunc

hi hsVarSym ctermfg=2
hi hsString ctermfg=6
hi hsStatement ctermfg=9

so ~/.vimrc_after
