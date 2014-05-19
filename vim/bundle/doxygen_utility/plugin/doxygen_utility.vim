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

	let declaration = s:CaptureOutputInRegister("normal! 0\"ay/;\<cr>") . ";"
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

func! s:GenerateMacroComment()
	" Inserts a Doxygen comment for a function-like macro.

	let doxygen_comment = "/*\n * @brief \n"

	let arg_string = matchstr(getline("."),
		\ '\(^\s*#define \S\+(\)\@<=[^)]*)\@=')
	if 0 < len(arg_string)
		let doxygen_comment .= "\n"
		for arg in split(substitute(arg_string, " ", "", "g"), ",")
			let doxygen_comment .= printf(" * @param %s () \n", arg)
		endfor
	endif

	set paste
	exe "normal! O" . doxygen_comment . " */"
	set nopaste
endfunc

func! s:GenerateFunctionComment()
	let doxygen_comment = "/*\n * @brief \n"

	let declaration = s:CaptureOutputInRegister("normal! 0\"ay/;\<cr>")
	let arg_string = matchstr(declaration, '(\@<=.*\()$\)\@=')

	if arg_string == "void"
		return
	endif

	if 0 < len(arg_string)
		let doxygen_comment  .= " *\n"
		for arg in split(arg_string, ",")
			let doxygen_comment .= printf(" * @param %s \n", split(arg)[-1])
		endfor
	endif

	if substitute(declaration, "^static ", "", "g") !~ '^void\s*[^*]'
		let doxygen_comment .= " *\n * @return \n"
	endif

	set paste
	exe "normal! O" . doxygen_comment . " */"
	set nopaste
endfunc

func! s:GenerateStructComment()
	echom "s:GenerateStructComment"
endfunc

func! s:GenerateFileHeaderComment()
	echom "s:GenerateFileHeaderComment"
endfunc

func! s:CaptureOutputInRegister(command_string)
	let currRegisterValue = @a
	silent! exec a:command_string
	let output = @a
	let @a = currRegisterValue
	return output
endfunc
