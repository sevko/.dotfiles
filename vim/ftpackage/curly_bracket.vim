nnorem <buffer> <leader>;
	\ :exe "norm! $" . ("{," =~ getline(".")[-1:]?"r":"a") . ";"<cr>
nnorem <buffer> { :call <SID>InsertBraces()<cr>
nnorem <buffer> } :call <SID>DeleteBraces()<cr>

inorem <buffer> & <space>&&<space>
inorem <buffer> && &
inorem <buffer> \| <space>\|\|<space>
inorem <buffer> \|\| \|

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
