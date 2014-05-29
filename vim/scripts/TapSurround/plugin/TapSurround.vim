" A plugin for easy paired-element manipulation.
"
" Contains functions for the painless insertion and deletion of paired
" surrounding elements (parentheses, double quotes, etc.)

func! s:ConfigurePlugin()
	" Configure the plugin's keymaps, variables, etc.

	if !exists("g:tap_surround_prefix")
		let g:tap_surround_prefix = "<leader>"
	endif

	let g:surround_close_char = {
		\"<" : ">",
		\"{" : "}",
		\"(" : ")",
		\'"' : '"',
		\"'" : "'",
		\"[" : "]",
		\"`" : "`"
	\}

	call s:CreateKeymaps()
endfunc

func! s:CreateKeymaps()
	" Create all normal/visual keymaps for tap_surround functions.

	for key in keys(g:surround_close_char)
		if l:key !~ "'"
			exe printf("norm! :nnorem <silent> %s%s :call " .
				\"TapSurround#NormalInsertElementPair('%s', '%s')<cr>\<cr>",
				\g:tap_surround_prefix, l:key, l:key,
				\g:surround_close_char[l:key])
			exe printf("norm! :nnorem <silent> %s%s :call " .
				\"TapSurround#NormalDeleteElementPair('%s', '%s')<cr>\<cr>",
				\g:tap_surround_prefix,
				\repeat(l:key, 2), l:key, g:surround_close_char[l:key])
			exe printf("norm! :vnorem <silent> %s%s :%scall " .
				\"TapSurround#VisualInsertElementPair('%s', '%s')<cr>\<cr>",
				\g:tap_surround_prefix, l:key,
				\repeat("<bs>", 5), l:key, g:surround_close_char[l:key])
		else
			exe printf("norm! :nnorem <silent> %s%s :call " .
				\'TapSurround#NormalInsertElementPair("%s", "%s")' . "<cr>\<cr>",
				\g:tap_surround_prefix, l:key, l:key,
				\g:surround_close_char[l:key])
			exe printf("norm! :nnorem <silent> %s%s :call " .
				\'TapSurround#NormalDeleteElementPair("%s", "%s")' . "<cr>\<cr>",
				\g:tap_surround_prefix, repeat(l:key, 2), l:key,
				\g:surround_close_char[l:key])
			exe printf("norm! :vnorem <silent> %s%s :%scall " .
				\'TapSurround#VisualInsertElementPair("%s", "%s")' . "<cr>\<cr>",
				\g:tap_surround_prefix, l:key, repeat("<bs>", 5), l:key,
				\g:surround_close_char[l:key])
		endif
	endfor
endfunc

silent! call s:ConfigurePlugin()
