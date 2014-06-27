func! PythonDocUtil#GenerateDocstring()
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

func! s:IsOnFunction()
	return getline(".") =~ '\s*def '
endfunc

func! s:IsOnClass()
	return getline(".") =~ '\s*class '
endfunc

func! s:IsOnModuleHeader()
	return line(".") == 1
endfunc

func! s:InsertFunctionComment()
	func! s:DocumentArguments()
		let args = split(
				\s:CaptureOutputInRegister('^/(\<cr>"ay/)\<cr>')[1:], ", ")

		if !empty(l:args)
			call remove(l:args, "self")
			return "\nArgs:\n" . join(map(l:args, '"\t" . v:val . "(): \n"'))
		else
			return ""
		endif
	endfunc

	func! s:DocumentReturnValue()
		return "\nReturns:\n"
	endfunc

	let comment_string = printf(
			\"\"\"\"\n%s%s\"\"\"", s:DocumentArguments(),
			\s:DocumentReturnValue())

	exe "norm! /):$\<cr>"
	call s:InsertIndentedTextBelowCurrentLine(
			\s:GetCurrentIndentLevel(), l:comment_string)
endfunc

func! s:InsertClassComment()
	echom "Comment inserted."
endfunc

func! s:InsertModuleComment()
	echom "Comment inserted."
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
	let tab_str = repeat("\t", a:indent_level)
	for line in split(a:text, "\n")
		call add(l:indented_lines, (0 < len(l:line)?(l:tab_str):("")) . l:line)
	endfor

	set paste
	exe "norm! o" . join(l:indented_lines, "\n")
	set nopaste
endfunc
