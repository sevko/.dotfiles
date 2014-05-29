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

func! s:CreateKeymaps()
	" Create all normal/visual keymaps for tap_surround functions.

	for key in keys(g:surround_close_char)
		exe printf("norm! :nnorem %s%s " .
			\":call NormalInsertElementPair('%s', '%s')<cr>\<cr>",
			\g:tap_surround_prefix, key, key, g:surround_close_char[key])
		exe printf("norm! :nnorem %s%s%s " .
			\":call NormalDeleteElementPair('%s', '%s')<cr>\<cr>",
			\g:tap_surround_prefix, key, key, key, g:surround_close_char[key])
		exe printf("norm! :vnorem %s%s " .
			\":%scall VisualInsertElementPair('%s', '%s')<cr>\<cr>",
			\g:tap_surround_prefix, key, repeat("<bs>", 5), key,
			\g:surround_close_char[key])
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
	"   open_delim : (str) The opening surrounding delimiter.
	"   open_delim : (str) The closing surrounding delimiter.

	let l:original_cur_col = col(".")
	let l:escaped_delims = [
		\escape(a:open_delim, "[]"),
		\escape(a:close_delim, "[]")
	\]

	if a:open_delim == "'" || a:close_delim == '"'
		exe 'norm! /[^\\]\@<=' . a:open_delim . "\<cr>x"
		exe 'norm! /\(^\|[^\\]\)\@<=' . a:open_delim . "\<cr>x"
		exe 'norm! ?[^\\]\@<=' . a:close_delim . "\<cr>x"
	elseif searchpair(l:escaped_delims[0], "", l:escaped_delims[1], "b") != 0
		exe "norm! " . repeat("x", len(a:open_delim))
		call searchpair(l:escaped_delims[0], "", l:escaped_delims[1])
		exe "norm! " . repeat("x", len(a:close_delim))
	endif

	call cursor(line("."), l:original_cur_col - len(a:open_delim))
endfunc

func! VisualInsertElementPair(open_delim, close_delim)
	" Insert opening and closing delimiters at the bounds of a visual
	" selection.

	call cursor(line("."), col("'<"))
	exe "norm! i" . a:open_delim
	call cursor(line("."), col("'>") + len(a:open_delim))
	exe "norm! a" . a:close_delim

	call cursor(line("."), col("'<") + len(a:open_delim))
endfunc

call s:CreateKeymaps()
