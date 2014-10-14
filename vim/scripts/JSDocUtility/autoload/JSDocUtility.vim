func! JSDocUtility#GenerateComment()
	if s:IsOnClass()
		call s:InsertClassComment()

	elseif s:IsOnFunction()
		call s:InsertFunctionComment()

	elseif s:IsOnFileHeader()
		call s:InsertFileHeaderComment()

	else
		echom "No JSDoc-documentable construct detected under the cursor."
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
endfunc

func! s:InsertStringAboveCurrentLine(string)
endfunc
