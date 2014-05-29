if !exists("g:tap_surround_prefix")
	let g:tap_surround_prefix = "<leader>"
endif

let g:surround_close_char = {
	\"<" : ">",
	\"{" : "}",
	\"(" : ")",
	\'"' : '"',
	\"''" : "''",
	\"[" : "]",
	\"`" : "`"
\}

func! s:CreateKeymaps()
	" Create all normal/visual keymaps for tap_surround functions.

	func! s:CreateNormalInsertKeymap(key, ...)
		" Create a keymap for s:NormalInsertElementPair().
		"
		" Args:
		"   key : (str) The delimiter to map.
		"   ... : (str) An optionally specified argument to pass into the
		"       mapped function.

		exe printf("norm! :nnorem %s%s " .
			\':call NormalInsertElementPair("%s", "%s")<cr>\<cr>',
			\g:tap_surround_prefix, (a:0 > 0)?(a:1):(a:key), a:key,
			\g:surround_close_char[a:key])
	endfunc

	func! s:CreateNormalDeleteKeymap(key, ...)
		" Create a keymap for s:NormalDeleteElementPair().
		"
		" Args:
		"   See s:CreateNormalInsertKeymap().

		exe printf("norm! :nnorem %s%s " .
			\':call NormalDeleteElementPair("%s", "%s")<cr>\<cr>',
			\g:tap_surround_prefix, repeat((a:0 > 0)?(a:1):(a:key), 2), a:key,
			\g:surround_close_char[a:key])
	endfunc

	func! s:CreateVisualInsertKeymap(key, ...)
		" Create a keymap for s:CreateVisualInsertKeymap().
		"
		" Args:
		"   See s:CreateNormalInsertKeymap().

		exe printf("norm! :vnorem %s%s " .
			\':%scall VisualInsertElementPair("%s", "%s")<cr>\<cr>',
			\g:tap_surround_prefix, (a:0 > 0)?(a:1):(a:key), repeat("<bs>", 5),
			\a:key, g:surround_close_char[a:key])
	endfunc

	for key in keys(g:surround_close_char)
		if key =~ '"'
			call s:CreateNormalInsertKeymap(key, "\"")
			call s:CreateNormalDeleteKeymap(key, "\"")
			call s:CreateVisualInsertKeymap(key, "\"")
		else
			call s:CreateNormalInsertKeymap(key)
			call s:CreateNormalDeleteKeymap(key)
			call s:CreateVisualInsertKeymap(key)
		endif
	endfor
endfunc

func! NormalInsertElementPair(open_delim, close_delim)
	" Enclose the string under the cursor with delimiters.
	"
	" If the character under the cursor is a non-word char, surround it;
	" otherwise, surround the word under the cursor at its boundaries.
	"
	" Args:
	"   open_delim : (str) The opening surrounding delimiter.
	"   open_delim : (str) The closing surrounding delimiter.

	let l:original_cur_col = col(".")

	if getline(".")[col(".") - 1] !~ '\w' || len(expand("<cword>")) == 1
		exe printf("norm! i%s\<esc>la%s", a:open_delim, a:close_delim)
	else
		if col(".") == 1 || getline(".")[col(".") - 2] =~ '\W'
			exe "norm! e"
		endif

		exe printf("norm! bi%s\<esc>ea%s", a:open_delim, a:close_delim)
	endif

	call cursor(line("."), l:original_cur_col + len(a:open_delim))
endfunc

func! NormalDeleteElementPair(open_delim, close_delim)
	" Delete a pair of surrounding elements.
	"
	" Args:
	"   See s:NormalInsertElementPair().

	let original_cur_col = col(".")

	func! s:IndexOfOpenDelim(open_delim, close_delim, start_ind)
		" Find an opening element.
		"
		" Finds the opening element corresponding to the nesting level of
		" a:start_ind, by backtracking along the current line. Delimiters
		" escaped with a backslash are taken into account.
		"
		" Args:
		"   open_delim : See s:NormalDeleteElementPair() a:open_delim.
		"   close_delim : See s:NormalDeleteElementPair() a:close_delim.
		"   start_ind : (int) The index to begin parsing from.
		"
		" Return:
		"   (int) The index of the opening element in the current line; if one
		"   isn't found, return -1.

		let nest_level = 0
		let curr_ln = getline(".")
		let curr_ind = a:start_ind

		while 0 <= l:curr_ind
			if l:curr_ln =~ printf('^%s%s%s', repeat(".", l:curr_ind - 1),
				\repeat('[^\\]', l:curr_ind > 0), a:open_delim)
				let nest_level -= 1
			elseif l:curr_ln =~ printf('^%s%s%s', repeat(".", l:curr_ind - 1),
				\repeat('[^\\]', l:curr_ind > 0), a:close_delim)
				let nest_level += 1
			endif

			if l:nest_level == -1
				break
			endif
			let l:curr_ind -= 1
		endwhile

		return l:curr_ind
	endfunc

	call cursor(line("."),
		\s:IndexOfOpenDelim(a:open_delim, a:close_delim, col(".") - 1) + 1)
endfunc

func! VisualInsertElementPair(open_delim, close_delim)
	" Insert opening and closing delimiters at the bounds of a visual
	" selection.
	"
	" Args:
	"   See s:NormalInsertElementPair().

	call cursor(line("."), col("'<"))
	exe "norm! i" . a:open_delim
	call cursor(line("."), col("'>") + len(a:open_delim))
	exe "norm! a" . a:close_delim

	call cursor(line("."), col("'<") + len(a:open_delim))
endfunc

call s:CreateKeymaps()
