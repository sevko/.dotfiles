func! PythonDocUtil#GenerateDocstring()
	" Generate a Google-style Python docstring for the line under the cursor.
	"
	" A docstring appropriate for the object present on the current line (a
	" function/class definition, or a module header); emits a warning if
	" nothing documentable is present.

	func! s:IsOnFunction()
		return getline(".") =~ '\s*def '
	endfunc

	func! s:IsOnClass()
		return getline(".") =~ '\s*class '
	endfunc

	func! s:IsOnModuleHeader()
		return line(".") == 1
	endfunc

	if s:IsOnFunction()
		call s:InsertFunctionComment()

	elseif s:IsOnClass()
		call s:InsertClassComment()

	elseif s:IsOnModuleHeader()
		call s:InsertModuleComment()

	else
		echom "No documentable object on current line."
	endif
endfunc

func! s:InsertFunctionComment()
	func! s:DocumentArguments()
		let args = split(
				\s:CaptureOutputInRegister("^/(\<cr>\"ay/)\<cr>")[1:], ", ")

		if !empty(l:args)
			call remove(l:args, "self")
			return "\nArgs:\n" . join(map(l:args, '"\t" . v:val . " (): \n"'))
		else
			return ""
		endif
	endfunc

	func! s:DocumentReturnOrYieldValue(func_def)
		let match = matchstr(a:func_def, '\v(\n\s*)@<=(return|yield) @=')
		echom l:match
		if !empty(l:match)
			return printf("\n%s%ss:\n\t\n", toupper(l:match[0]), l:match[1:])
		else
			return ""
		endif
	endfunc

	func! s:DocumentExceptions(func_def)
		let matches = []
		for line in split(a:func_def, "\n")
			let match = matchstr(l:line, '\v(^\s*raise )@<=\w+')
			if !empty(l:match)
				call add(l:matches, match)
			endif
		endfor

		if !empty(l:matches)
			return printf(
					\"\nRaises:\n%s\n",
					\join(map(l:matches, "'\t' . v:val . ': '"), "\n"))
		else
			return ""
		endif
	endfunc

	let func_def = s:GetPythonBlock()
	let comment_string = printf(
			\"\"\"\"\n%s%s%s\"\"\"", s:DocumentArguments(),
			\s:DocumentReturnOrYieldValue(l:func_def),
			\s:DocumentExceptions(l:func_def))

	exe "norm! /):$\<cr>"
	call s:InsertIndentedTextBelowCurrentLine(
			\s:GetCurrentIndentLevel(), l:comment_string)
	call s:GetPythonBlock()
endfunc

func! s:InsertClassComment()
	echom "Comment inserted."
endfunc

func! s:InsertModuleComment()
	echom "Comment inserted."
endfunc

func! s:GetPythonBlock()
	return s:CaptureOutputInRegister(printf(
			\"\"ay/\\v^\t{,%d}\\S|%%$\<cr>", s:GetCurrentIndentLevel()))
endfunc

func! s:CaptureOutputInRegister(command_string)
	" Execute a vim command using the `a` register to store data, and return
	" the register's contents; then, reset the register's value to whatever it
	" was originally.
	"
	" Args:
	"   command_string : (str) The command to execute.

	let currRegisterValue = @a
	silent! exe "norm! " . a:command_string
	let output = @a
	let @a = l:currRegisterValue
	return l:output
endfunc

func! s:GetCurrentIndentLevel()
	return len(matchstr(getline("."), "^\t*"))
endfunc

func! s:InsertIndentedTextBelowCurrentLine(indent_level, text)
	let indented_lines = []
	let tab_str = repeat("\t", a:indent_level + 1)
	for line in split(a:text, "\n")
		call add(l:indented_lines, (0 < len(l:line)?(l:tab_str):("")) . l:line)
	endfor

	set paste
	exe "norm! o" . join(l:indented_lines, "\n")
	set nopaste
endfunc
