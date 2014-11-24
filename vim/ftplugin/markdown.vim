setl spell spelllang=en_us
setl iskeyword-=.
setl ts=4 sw=4
setl expandtab
so ~/.vimrc_after

unlet b:current_syntax
syn include @latex syntax/tex.vim
syn region _markdown_math_inline start="\V$" end="\V$" contains=@latex keepend
syn region _markdown_math_block start="\V$$" end="\V$$" contains=@latex keepend

hi htmlItalic cterm=underline
hi markdownCode ctermfg=2

au QuitPre <buffer> Grip stop

inore <buffer> * <c-r>=<SNR>SmartItalics()<cr>
inore <buffer> ** *<left>

" inore <buffer> <cr> <esc>:call <SID>AutoIncrementList()<cr>a
" nnore <buffer> o $<esc>:call <SID>AutoIncrementList()<cr>a

func! s:PrettifyTable()
	" Pretty-format the markdown table under the cursor.
	"
	" Reformats the markdown table that begins on the current line and
	" continues until either a blank line or the end of the file; will pad the
	" value in each row of a column with whitespace until it's as long as the
	" longest value in that column. Performs some additional processing.
	"
	" The following table, for instance:
	"
	" col1|col2|col3
	" ||
	" a|b|c
	" d|e|f
	" g|h|i
	"
	" would be converted to:
	"
	"  col1 | col2 | col3
	"  ---- | ---- | ----
	"   a   |  b   |  c
	"   d   |  e   |  f
	"   g   |  h   |  i

	let startLine = line(".")
	/\n^$\|\%$
	let endLine = line(".")
	let numLines = l:endLine - l:startLine + 1
	call cursor(l:startLine, 0)
	let rowStrings = getline(l:startLine, l:endLine)

	let table = []
	for l:rowString in l:rowStrings
		let cells = []
		for l:cell in split(l:rowString, "|", 1)
			call add(l:cells, l:cell)
		endfor
		call add(l:table, l:cells)
	endfor

	let numCols = len(l:table[0])
	let colMaxLengths = repeat([0], l:numCols)

	for l:row in l:table
		for l:ind in range(l:numCols)
			let colLen = len(l:row[l:ind])
			if l:colLen > l:colMaxLengths[l:ind]
				let l:colMaxLengths[l:ind] = l:colLen
			endif
		endfor
	endfor

	for l:ind in range(l:numCols)
		let table[1][l:ind] = repeat("-", l:colMaxLengths[l:ind])
	endfor

	let formattedRowStrings = []
	for l:row in l:table
		let formattedCells = []
		for l:ind in range(numCols - 1)
			let padding = l:colMaxLengths[l:ind] - len(l:row[l:ind]) + 2
			let leftPadding = l:padding / 2
			let formattedCell = repeat(" ", l:leftPadding) . l:row[l:ind] .
				\ repeat(" ", l:padding - l:leftPadding)
			call add(l:formattedCells, l:formattedCell)
		endfor

		let padding = l:colMaxLengths[-1] - len(l:row[-1]) + 2
		let lastCell = repeat(" ", l:padding / 2) . l:row[-1]
		call add(l:formattedCells, lastCell)

		call add(l:formattedRowStrings, join(l:formattedCells, "|"))
	endfor

	exe "norm! " . l:numLines . "dd"
	call append(l:startLine - 1, l:formattedRowStrings)
endfunc

func! s:SmartItalics()
	if getline(".")[:col(".") - 1] !~ '^ \+$'
		return "**\<left>"
	else
		return "* "
	endif
endfunc

com! -nargs=1 Grip :call <SID>Grip("<args>")

func! s:Grip(action)
	" Start/stop `grip` in the background for the markdown file in the current
	" buffer.
	"
	" Args:
	"   action: (string) Either "start" or "stop", to start/stop the Grip
	"       server.

	let grip_running = exists("b:grip_pid")
	if a:action == "start" && !l:grip_running
		let filepath = expand("%:p")
		let b:grip_pid = system(printf("grip %s & echo -n $!", l:filepath))
	elseif a:action == "stop" && l:grip_running
		echom "Called: " . a:action . " " . b:grip_pid
		call system("kill " . b:grip_pid)
		unlet b:grip_pid
	endif
endfunc
