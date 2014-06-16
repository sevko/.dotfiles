func! DoxygenUtility#GenerateDoxygenComment()
	" Detect any Doxygen-documentable statements in the current line and, if
	" there are any, insert an appropriate comment template.

	if s:IsOnMacro()
		call s:InsertMacroComment()

	elseif s:IsOnFunction()
		call s:InsertFunctionComment()

	elseif s:IsOnFileHeader()
		call s:InsertFileHeaderComment()

	elseif s:IsOnStruct()
		call s:InsertStructComment()

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

	let declaration = s:CaptureOutputInRegister("0\"ay/;\<cr>") . ";"
	return declaration =~ "^[^\\t\\n]*(\\([^)]*\\n\\?\\)*);"
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

func! s:InsertMacroComment()
	" Inserts a Doxygen comment for a function-like macro.

	let doxygen_comment = "/*\n * @brief \n"

	let arg_string = matchstr(getline("."),
		\ '\(^\s*#define \S\+(\)\@<=[^)]*)\@=')
	if 0 < len(arg_string)
		let doxygen_comment .= " *\n"
		for arg in split(substitute(arg_string, " ", "", "g"), ",")
			let doxygen_comment .= printf(" * @param %s () \n", arg)
		endfor
	endif

	call s:InsertStringAboveCurrentLine(doxygen_comment . "*/")
endfunc

func! s:InsertFunctionComment()
	" Insert a Doxygen comment for a function.

	let doxygen_comment = "/*\n * @brief \n"

	let declaration = s:CaptureOutputInRegister("0\"ay/;\<cr>")
	let arg_string = matchstr(declaration, '(\@<=.*\()$\)\@=')

	if 0 < len(arg_string) && arg_string != "void"
		let doxygen_comment .= " *\n"
		for arg in split(arg_string, ",")
			let arg_name = split(arg)[-1]
			let doxygen_comment .= printf(" * @param %s \n",
				\(l:arg_name[0] != "*")?(l:arg_name):(l:arg_name[1:]))
		endfor
	endif

	if substitute(declaration, "^static ", "", "g") !~ '^void\s*[^*]'
		let doxygen_comment .= " *\n * @return \n"
	endif

	call s:InsertStringAboveCurrentLine(doxygen_comment . "*/")
endfunc

func! s:InsertStructComment()
	" Inserts Doxygen comments into a struct definition.

	exe "norm! O//\<esc>/{\<cr>"
	let num_struct_lines = len(
		\ split(s:CaptureOutputInRegister("\"ay/}\<cr>"), "\n")) - 1
	exe "norm! :.,+" . num_struct_lines . "s/;$/; \\/\\/ \<cr>"
endfunc

func! s:InsertFileHeaderComment()
	" Insert a Doxygen comment for a file header.

	let doxygen_comment = "/*\n * @file\n * @brief \n*/"
	call s:InsertStringAboveCurrentLine(doxygen_comment)
endfunc

func! s:CaptureOutputInRegister(command_string)
	" Execute a vim command using the `a` register to store data, and return
	" the register's contents; then, reset the register's value to whatever it
	" was originally.
	"
	" Args:
	"   command_string : (str) The command to execute.

	let currRegisterValue = @a
	silent! exec "norm! " . a:command_string
	let output = @a
	let @a = currRegisterValue
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
