func! TapSurround#NormalInsertElementPair(open_delim, close_delim)
	" Enclose the string under the cursor with delimiters.
	"
	" If the character under the cursor is a non-word char, surround it;
	" otherwise, surround the word under the cursor at its boundaries.
	"
	" Args:
	"   open_delim : (str) The opening surrounding delimiter.
	"   open_delim : (str) The closing surrounding delimiter.

	let l:original_cur_col = col(".")

	if getline(".")[col(".") - 1] !~ '\k' || len(expand("<cword>")) == 1
		exe printf("norm! i%s\<esc>la%s", a:open_delim, a:close_delim)
	else
		if col(".") == 1 || getline(".")[col(".") - 2] =~ '\W'
			exe "norm! e"
		endif

		exe printf("norm! bi%s\<esc>ea%s", a:open_delim, a:close_delim)
	endif

	call cursor(line("."), l:original_cur_col + len(a:open_delim))
endfunc

func! TapSurround#NormalDeleteElementPair(open_delim, close_delim)
	" Delete a pair of surrounding elements.
	"
	" Args:
	"   See s:NormalInsertElementPair().

	let original_cur_col = col(".")

	func! s:IndexOfUnescapedOpenDelim(open_delim, close_delim, start_ind)
		" Find the opening element.
		"
		" Finds the opening element corresponding to the nesting level of
		" a:start_ind, by backtracking along the current line. Delimiters
		" escaped with a backslash are accounted for.
		"
		" Args:
		"   open_delim : See s:NormalDeleteElementPair() a:open_delim.
		"   close_delim : See s:NormalDeleteElementPair() a:close_delim.
		"   start_ind : (int) The index to begin parsing from.
		"
		" Return:
		"   (int) The index of the opening element in the current line; if one
		"   isn't found, returns -1.

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

	func! s:IndexOfUnescapedCloseDelim(open_delim, close_delim, start_ind)
		" Find the closing element.
		"
		" Finds the closing element corresponding to the nesting level of
		" a:start_ind, by marching forward along the current line. Delimiters
		" escaped with a backslash are accounted for.
		"
		" Args:
		"   open_delim : See s:NormalDeleteElementPair() a:open_delim.
		"   close_delim : See s:NormalDeleteElementPair() a:close_delim.
		"   start_ind : (int) The index to begin parsing from.
		"
		" Return:
		"   (int) The index of the closing element in the current line; if one
		"   isn't found, return -1.

		let nest_level = 0
		let curr_ln = getline(".")
		let curr_ind = a:start_ind

		while l:curr_ind < len(l:curr_ln)
			let l:curr_ln_remainder = l:curr_ln[(l:curr_ind):]
			if l:curr_ln_remainder =~ '^[^\\]' . a:close_delim
				let nest_level -= 1
			elseif l:curr_ln_remainder =~ '^[^\\]' . a:open_delim
				let nest_level += 1
			endif

			if l:nest_level == -1
				break
			endif
			let l:curr_ind += 1
		endwhile

		return (l:curr_ind < len(l:curr_ln))?(l:curr_ind + 1):(-1)
	endfunc

	let open_delim_ind = s:IndexOfUnescapedOpenDelim(a:open_delim,
		\a:close_delim, col(".") - 1)
	let close_delim_ind = s:IndexOfUnescapedCloseDelim(a:open_delim,
		\a:close_delim, col(".") - 1)

	if l:open_delim_ind != -1
		call cursor(line("."), l:open_delim_ind + 1)
		exe "norm! " . repeat("x", len(a:open_delim))
	endif

	if l:close_delim_ind != -1
		call cursor(line("."), l:close_delim_ind)
		exe "norm! " . repeat("x", len(a:close_delim))
	endif

	if l:open_delim_ind != -1 || l:close_delim_ind != -1
		call cursor(line("."), l:original_cur_col - len(a:open_delim))
	endif
endfunc

func! TapSurround#VisualInsertElementPair(open_delim, close_delim)
	" Insert opening and closing delimiters at the bounds of a visual
	" selection.
	"
	" Args:
	"   See s:NormalInsertElementPair().

	let close_offset = (line("'<") == line("'>"))?len(a:open_delim):0

	call cursor(line("'<"), col("'<"))
	exe "norm! i" . a:open_delim
	call cursor(line("'>"), col("'>") + l:close_offset)
	exe "norm! a" . a:close_delim

	call cursor(line("."), col("'<") + l:close_offset)
endfunc
