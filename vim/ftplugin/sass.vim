setl iskeyword+=@-@,$,-
setl iskeyword-=:

syn match Comment "\/\/.*$" containedin=ALL
syn clear cssInclude
syn match _sass_delimiter "[:,]"
syn region _sass_media matchgroup=_sass_media_query start="@media" end="$"
syn match _sass_media_prop "\v[a-z-]*(:)@=" containedin=_sass_media contained
syn match _sass_media_attr "\v(: )@<=[^,)]*" containedin=_sass_media contained
syn keyword _sass_media_operator and not only containedin=_sass_media contained

hi _sass_media_query ctermfg=5
hi _sass_media_prop ctermfg=3
hi _sass_media_attr ctermfg=6
hi link _sass_delimiter Delimiter
hi link _sass_media_operator Operator

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
