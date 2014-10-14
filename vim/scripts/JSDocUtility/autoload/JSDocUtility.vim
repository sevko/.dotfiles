func! JSDocUtility#GenerateComment()
	" Detect any JSDoc-documentable statements in the current line and, if
	" there are any, insert an appropriate comment template.

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
endfunc

func! s:IsOnFunction()
endfunc

func! s:IsOnFileHeader()
endfunc

func! s:InsertFunctionComment()
endfunc

func! s:InsertClassComment()
endfunc

func! s:InsertFileHeaderComment()
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
