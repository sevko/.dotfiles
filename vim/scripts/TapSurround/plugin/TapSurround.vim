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
		if key !~ "'"
			exe printf("nnorem <silent> %s%s :call " .
				\"TapSurround#NormalInsertElementPair('%s', '%s')<cr>",
				\g:tap_surround_prefix, key, key, g:surround_close_char[key])
			exe printf("nnorem <silent> %s%s :call " .
				\"TapSurround#NormalDeleteElementPair('%s', '%s')<cr>",
				\g:tap_surround_prefix, repeat(key, 2), key,
				\g:surround_close_char[key])
			exe printf("vnorem <silent> %s%s :%scall " .
				\"TapSurround#VisualInsertElementPair('%s', '%s')<cr>",
				\g:tap_surround_prefix, key, repeat("<bs>", 5), key,
				\g:surround_close_char[key])
		else
			exe printf("nnorem <silent> %s%s :call " .
				\'TapSurround#NormalInsertElementPair("%s", "%s")' . "<cr>",
				\g:tap_surround_prefix, key, key, g:surround_close_char[key])
			exe printf("nnorem <silent> %s%s :call " .
				\'TapSurround#NormalDeleteElementPair("%s", "%s")' . "<cr>",
				\g:tap_surround_prefix, repeat(key, 2), key,
				\g:surround_close_char[key])
			exe printf("vnorem <silent> %s%s :%scall " .
				\'TapSurround#VisualInsertElementPair("%s", "%s")' . "<cr>",
				\g:tap_surround_prefix, key, repeat("<bs>", 5), key,
				\g:surround_close_char[key])
		endif
	endfor
endfunc

silent! call s:ConfigurePlugin()
