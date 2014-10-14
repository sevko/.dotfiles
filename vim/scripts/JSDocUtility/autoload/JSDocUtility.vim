func! JSDocUtility#GenerateComment()
	" Detect any JSDoc-documentable statements (class constructors, other
	" functions, and file header) in the current line and, if there are any,
	" insert an appropriate comment template.

	if s:IsOnClass()
		call s:InsertClassComment()

	elseif s:IsOnFunction()
		call s:InsertFunctionComment()

	elseif s:IsOnFileHeader()
		call s:InsertFileHeaderComment()

	else
		echom "No JSDoc-documentable type detected under cursor."
	endif
endfunc

func! s:IsOnClass()
	" Return a 1 if the user's cursor is on a line containing a class macro
	" declaration; otherwise, return 0.

	return getline(".") =~ 'function \u'
endfunc

func! s:IsOnFunction()
	" Return a 1 if the user's cursor is on a line containing a function
	" prototype; otherwise, return 0.

	return getline(".") =~ 'function'
endfunc

func! s:IsOnFileHeader()
	" Return a 1 if the user's cursor is on a blank line at the top of a file.

	return line(".") == 1
endfunc

func! s:InsertFunctionComment()
	" Insert a JSDoc comment for a function.

	let doc_comment = "/**\n * \n"

	" Find function arguments and insert `@param` accordingly.
	let declaration = s:CaptureOutputInRegister("0y/{\<cr>")
	let arg_string = matchstr(declaration, '(\@<=.*\()$\)\@=')
	if 0 < len(arg_string)
		for arg in split(arg_string, ",")
			let arg_name = substitute(l:arg, '^\s\+\|\s\+$', "", "g")
			let doc_comment .= printf(" * @param {} %s \n", l:arg_name)
		endfor
	endif

	" Find `return` statements and insert `@return` accordingly.
	let definition = s:GetJavascriptBlock()
	let match = matchstr(l:definition, "return ")
	if !empty(l:match)
		let doc_comment .= " * @return {} \n"
	endif

	call s:InsertStringAboveCurrentLine(doc_comment . " */")
endfunc

func! s:InsertClassComment()
	" Inserts JSDoc comments into a class definition.

	let prop_names = []
	let definition = s:GetJavascriptBlock()
	for snippet in split(l:definition, 'this\.')[1:]
		let prop_name = matchstr(l:snippet, '^\w\+')
		if index(l:prop_names, l:prop_name) == -1
			call add(l:prop_names, l:prop_name)
		endif
	endfor

	let doc_comment = "/**\n * @brief \n"
	let doc_comment .= join(
		\map(l:prop_names, "' * @property {} ' . v:val . ' \n'"), ""
	\)

	call s:InsertStringAboveCurrentLine(l:doc_comment . " */")
endfunc

func! s:InsertFileHeaderComment()
	" Insert a JSDoc comment for a file header.

	let doc_comment = "/**\n * @file \n */"
	if 0 < len(getline("."))
		exe "norm! O"
	endif
	call s:InsertStringAboveCurrentLine(doc_comment)
endfunc

func! s:CaptureOutputInRegister(command_string)
	" Execute a vim command using the anonymous register to store data, and
	" return the register's contents; then, reset the register's value to
	" whatever it was originally.
	"
	" Args:
	"   command_string : (str) The command to execute.

	let currRegisterValue = @"
	silent! exec "norm! " . a:command_string
	let output = @"
	let @" = currRegisterValue
	return output
endfunc

func! s:InsertStringAboveCurrentLine(string)
	" Insert a string above the cursor's line, while ignoring mappings,
	" abbreviations, and other insert-mode modifiers.
	"
	" Args:
	"   string : (str) The string to insert.

	set paste
	exe "normal! O" . a:string
	set nopaste
endfunc

func! s:GetJavascriptBlock()
	" Returns:
	"   (str) The entire Javascript block (function, conditional, etc.;
	"   anything delimited by braces and with a properly indented body) that's
	"   opened on the current line.

	let indent_str = matchstr("^\t\+", getline("."))
	return s:CaptureOutputInRegister("0y/" . l:indent_str . "}\<cr>")
endfunc
