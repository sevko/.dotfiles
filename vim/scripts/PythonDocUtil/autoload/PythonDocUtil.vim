" A plugin that generates Python Google-style docstrings.
"
" `PythonDocUtil.vim` supports function, class, and module header docstring
" generation, parsing definition blocks to identify whether documentation for,
" say, return values or instance variables is necessary.

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
	" Insert a function docstring.
	"
	" The docstring may contain the following specifiers: `Returns:`,
	" `Yields:`, `Args:`, and `Raises:`.

	func! s:DocumentArguments()
		" Returns:
		"   (str) A documentation section for the function's arguments.

		let args = split(
				\s:CaptureOutputInRegister("^/(\<cr>y/)\<cr>")[1:], ", ")

		if -1 < index(l:args, "self")
			call remove(l:args, "self")
		endif

		if !empty(l:args)
			return "\nArgs:\n" . join(
					\map(l:args, '"\t" . v:val . " (): \n"'), "")
		else
			return ""
		endif
	endfunc

	func! s:DocumentReturnOrYieldValue(func_def)
		" Args:
		"   func_def (str): The function body, or definition.
		"
		" Returns:
		"   (str) A documentation section for the function's `return`/`yield`
		"   statements, if any.

		" Disregard nested functions with return/yield statements.
		let tab_str = repeat("\t", s:GetCurrentIndentLevel() + 1)
		let match = matchstr(
			\a:func_def, '\v(\n' . l:tab_str . ')@<=(return|yield) @='
		\)

		if !empty(l:match)
			return printf("\n%s%ss:\n\t\n", toupper(l:match[0]), l:match[1:])
		else
			return ""
		endif
	endfunc

	func! s:DocumentExceptions(func_def)
		" Args:
		"   func_def (str): The function body, or definition.
		"
		" Returns:
		"   (str) A documentation section for the function's `raise`
		"   statements.

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
endfunc

func! s:InsertClassComment()
	" Insert a class docstring comment.
	"
	" May contain an `Attributes` specifier.

	func! s:GetClassInstanceVariables()
		" Returns:
		"   (list of str) All of the instance variables belonging to the class
		"   contained in the following Python block.

		let instance_vars = []
		for snippet in split(s:GetPythonBlock(), '\Vself.')[1:]
			let member = matchstr(l:snippet, '\v^\w+.')
			if l:member[-1:] != "(" && l:member !~ "__.*__" &&
					\index(l:instance_vars, l:member[:-2]) == -1
				call add(l:instance_vars, l:member[:-2])
			endif
		endfor
		return l:instance_vars
	endfunc

	let comment_string = '"""' . "\n\n"
	let instance_vars = s:GetClassInstanceVariables()
	if !empty(l:instance_vars)
		let comment_string .= "Attributes:\n" . join(
				\map(l:instance_vars, "'\t' . v:val . ' (): \n'"), "")
	endif
	call s:InsertIndentedTextBelowCurrentLine(
			\s:GetCurrentIndentLevel(), l:comment_string . '"""')
endfunc

func! s:InsertModuleComment()
	" Insert a module header docstring.

	exe "norm! O\"\"\"\<cr>\<cr>\"\"\""
endfunc

func! s:GetPythonBlock()
	" Returns:
	"   (str) The Python block following the current line (indented an
	"   additional level).

	return s:CaptureOutputInRegister(printf(
			\"y/\\v^\t{,%d}\\S|%%$\<cr>", s:GetCurrentIndentLevel()))
endfunc

func! s:CaptureOutputInRegister(command_string)
	" Wrapper for register-based value retrieval.
	"
	" Execute a vim command using the anonymous register to store data, and
	" return the register's contents; then, reset the register's value to
	" whatever it was originally.
	"
	" Args:
	"   command_string : (str) The command to execute.

	let currRegisterValue = @"
	silent! exe "norm! " . a:command_string
	let output = @"
	let @" = l:currRegisterValue
	return l:output
endfunc

func! s:GetCurrentIndentLevel()
	" Returns:
	"   (int) The number of indents the line under the cursor contains.

	return len(matchstr(getline("."), "^\t*"))
endfunc

func! s:InsertIndentedTextBelowCurrentLine(indent_level, text)
	" Inserts text underneath the current line, with all formatting preserved
	" and each line indented.
	"
	" Args:
	"   indent_level (int): the number of indents in the line under the cursor
	"   text (str): Text to be inserted.

	let indented_lines = []
	let tab_str = repeat("\t", a:indent_level + 1)
	for line in split(a:text, "\n")
		call add(l:indented_lines, (0 < len(l:line)?(l:tab_str):("")) . l:line)
	endfor

	set paste
	exe "norm! o" . join(l:indented_lines, "\n")
	set nopaste
endfunc
