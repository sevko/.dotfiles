setl iskeyword+=@-@,$,-
setl iskeyword-=:

syn match Comment "\/\/.*$" containedin=ALL

hi cssURL ctermfg=1
hi sassClass ctermfg=14

nnorem <buffer> <leader>cs :
	\exec "!sass ". expand("%:p:") . " " . expand("%:p:r") . ".css"
nnorem <buffer> <leader>s :call <SID>SortRulesAlphabetically()<cr>
inorem <buffer> : <c-r>=getline(".")[col(".") - 2] == "&"?":":": "<cr>

func! s:SortRulesAlphabetically()
	let start_pos = getcurpos()
	let indent_level = len(matchstr(getline("."), "^\t*"))
	exe printf("norm! ?^$\\|^%s\\S\<cr>", repeat("\t", l:indent_level - 1))
	exe "norm! jv/^$\<cr>k:sort\<cr>"
	call cursor(l:start_pos)
endfunc

so ~/.vimrc_after
