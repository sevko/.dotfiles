" =============== Settings ===============

	if !exists("g:toggle_surround")
		let g:toggle_surround = 0
	endif

	if !exists("g:suround_close_char")
		let surround_close_char = {
			\"<" : ">",
			\"{" : "}",
			\"(" : ")",
			\'"' : '"',
			\"'" : "'",
			\"[" : "]",
			\"`" : "`"
		\}
	endif

	if g:toggle_surround == 1
		for open_char in keys(g:surround_close_char)
			exec "nnoremap <leader>" . open_char .
				\" :call SurroundToggle(\"" . open_char . "\")\<cr>"
		endfor

		" to override for-loop map, which can't possibly map both ' and "
		nnoremap    <leader>"     :call SurroundToggle('"')<cr>
	else
		for open_char in keys(g:surround_close_char)
			exec "nnoremap <leader>" . open_char .
				\" :call DemandInsert(\"" . open_char . "\")\<cr>"
			exec "nnoremap <leader>" . open_char . open_char .
				\" :call DemandDelete(\"" . open_char . "\")\<cr>"
			exec "vnoremap <leader>" . open_char .
				\" :call BlockToggle(\"" . open_char . "\")\<cr>"
		endfor

		" to override for-loop map, which can't possibly map both ' and "
		nnoremap    <leader>"     :call DemandInsert('"')<cr>
		nnoremap    <leader>""    :call DemandDelete('"')<cr>
		vnoremap    <leader>"     :call BlockToggle('"')<cr>
	endif

" =============== Functions ===============

	func! SurroundToggle(openChar)
		let startCol = col('.')
		let closeChar = g:surround_close_char[a:openChar]

		if Surrounded(a:openChar, closeChar)
			call SurroundDelete(a:openChar, closeChar)
			cal cursor('.', startCol - 1)
		else
			call SurroundInsert(a:openChar, closeChar)
			cal cursor('.', startCol + 1)
		endif
	endfunc

	func! SurroundInsert(openChar, closeChar)
		exec 'normal! "zyw'

		if col('.') == 1
			exec "normal! l"
			exec "normal! bi" . a:openChar
			exec "normal! ea" . a:closeChar
		else
			exec "normal! h"
			exec "normal! ea" . a:closeChar
			exec "normal! bi" . a:openChar
		endif
	endfunc

	func! DemandInsert(openChar)
		let closeChar = g:surround_close_char[a:openChar]
		let startCol = col('.')
		call SurroundInsert(a:openChar, closeChar)
		cal  cursor('.', startCol + 1)
	endfunc

	func! SurroundDelete(openChar, closeChar)
		exec "normal! ?" . a:openChar . "\<cr>x"
		exec "normal! /" . a:closeChar . "\<cr>x"
	endfunc

	func! DemandDelete(openChar)
		let startCol = col('.')
		let closeChar = g:surround_close_char[a:openChar]
		if Surrounded(a:openChar, closeChar)
			call SurroundDelete(a:openChar, closeChar)
			cal cursor('.', startCol - 1)
		endif
	endfunc

	func! BlockToggle(openChar)
		let closeChar = g:surround_close_char[a:openChar]
		let start = getline("'<")[col("'<") - 1]
		let end = getline("'>")[col("'>") - 1]

		if start ==# a:openChar && end ==# closeChar
			cal cursor(line("'<"), col("'<"))
			exec "normal! x"
			cal cursor(line("'>"), col("'>") - 1)
			exec "normal! x"
		else
			cal cursor(line("'<"), col("'<"))
			exec "normal! i" . a:openChar
			cal cursor(line("'>"), col("'>") + 1)
			exec "normal! a" . closeChar
		endif
	endfunc

	func! Surrounded(openChar, closeChar)
		if a:openChar ==# a:closeChar
			return CountOccur(a:openChar) % 2 == 1
		else
			return CountOccur(a:openChar) != CountOccur(a:closeChar)
		endif
	endfunc

	func! CountOccur(char)
		let currLn = getline('.')
		let occurChar = 0
		let index = 0

		while index < col('.')
			if currLn[index] ==# a:char && currLn[index - 1] != "\\"
				let occurChar += 1
			endif
			let index += 1
		endwhile

		return occurChar
	endfunc
