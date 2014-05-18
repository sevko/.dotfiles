" Syntax highlighting
noremap <leader>d :call GenerateDoxygenComment()<cr>

" Functions
func! GenerateDoxygenComment()
	if s:IsOnMacro()
		call s:GenerateMacroComment()

	elseif s:IsOnFunction()
		call s:GenerateFunctionComment()

	elseif s:IsOnFileHeader()
		call s:GenerateFileHeaderComment()

	elseif s:IsOnStruct()
		call s:GenerateStructComment()

	else
		echom "No Doxygen-documentable type detected under cursor."
	endif
endfunc

func! s:IsOnMacro()
	" Return a 1 if the user's cursor is on a line containing a function-like
	" macro declaration; otherwise, return 0.

	return getline(".") =~ "^\\s*#define\\s\\S*("
endfunc

func! s:IsOnFunction()
	" Return a 1 if the user's cursor is on a line containing a function
	" declaration; otherwise, return 0.

	let registerTemp = @a
	silent! exec "normal! 0\"ay/;\<cr>"
	let isOnFunction = @a . ";"
		\ =~ "^\\(static\\)\\@![^\\t\\n]*(\\([^)]*\\n\\?\\)*);"
	let @a = registerTemp
	return isOnFunction
endfunc

func! s:IsOnStruct()
	" Return a 1 if the user's cursor is on a line containing a struct macro
	" declaration; otherwise, return 0.

	return getline(".") =~ "^\\s*\\(typedef \\)\\?struct"
endfunc

func! s:IsOnFileHeader()
	" Return a 1 if the user's cursor is on a blank line at the top of a file.

	return line(".") == 1 && len(getline(".")) == 0
endfunc

func! s:GenerateMacroComment()
	echom "s:GenerateMacroComment"
endfunc

func! s:GenerateFunctionComment()
	echom "s:GenerateFunctionComment"
endfunc

func! s:GenerateStructComment()
	echom "s:GenerateStructComment"
endfunc

func! s:GenerateFileHeaderComment()
	echom "s:GenerateFileHeaderComment"
endfunc
