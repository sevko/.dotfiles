set noet softtabstop=0 ts=4 sw=4
set iskeyword+=.,\

Synclude arithmetic_operator ctermfg=3
Synclude bitwise_operator ctermfg=1
Synclude constant cterm=bold ctermfg=14
Synclude equality_operator ctermfg=4
Synclude surrounding_element ctermfg=2
syn match _delimiter "[,:.]"

syn match pythonStrFormatting
	\ "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]"
	\ contained containedin=pythonString,pythonRawString
syn match pythonStrFormatting
	\ "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]"
	\ contained containedin=pythonString,pythonRawString
syn match _pythonImportedModule "\v((import|from) )@<=\S+"
syn match _pythonSphinxField "\(^[\t ]*\)\@<=:[^:]\+:" containedin=Comment
syn match _pythonSphinxStandardDomain "\.\. [^:]\+::" containedin=Comment
syn match _pythonSphinxReference ":[^:]\+:`[^\t`]\+`" containedin=Comment
syn match _pythonSphinxBold "\*\*[^\*]\+\*\*" containedin=Comment
syn match _pythonMagic "__[a-zA-Z]\+__"
syn keyword _pythonKeyword self
syn region Comment start=/\("""\|'''\)/ end=/\("""\|'''\)/

hi _delimiter ctermfg=242
hi _pythonImportedModule ctermfg=6
hi _pythonDocstringBrief cterm=bold ctermfg=10
hi _pythonKeyword ctermfg=3
hi _pythonMagic ctermfg=9
hi _pythonSphinxField cterm=bold ctermfg=10
hi _pythonSphinxStandardDomain cterm=bold ctermfg=10
hi _pythonSphinxReference cterm=bold ctermfg=10
hi _pythonSphinxItalics cterm=italic ctermfg=10
hi _pythonSphinxBold cterm=bold ctermfg=10
hi pythonFunction ctermfg=4
hi pythonStatement cterm=reverse,bold ctermfg=0 ctermbg=2
hi pythonStrFormatting ctermfg=5

nnorem <buffer> <leader>d :call SphinxComment()<cr>o
inorem <buffer> __ ____<left><left>

func! SphinxComment()
	" Insert a Sphinx docstring appropriate for the current line.
	"
	" Class and function declarations will received class and function
	" docstrings, while an empty line will receive a module docstring.

	call GetCurrentIndent()
	let curr_line = substitute(getline("."), "\\n", " ", "g")
	let curr_line = substitute(curr_line, g:_tab, "", "g")

	if line(".") > 1 && len(curr_line) == 0
		echom "Error: current line is the first in the module, or a class or
			\ function definition."
		return
	endif

	let curr_line_words = split(curr_line)

	if line(".") == 1
		let @a = ModuleComment()
		if len(getline(".")) != 0
			exec "normal! O"
		endif
		exec "normal! \"aP"

	elseif curr_line_words[0] == "def"
		exec "normal! 0\"ay/\\():\\)\\@<=$\<cr>"
		let func = substitute(substitute(@a, "\\n", " ", "g"), g:_tab, "", "g")
		let @a = FunctionComment(func)
		exec "normal! \"ap"

	elseif curr_line_words[0] == "class"
		let @a = ClassComment()
		exec "normal! \"ap"
	endif
endfunc

func! FunctionComment(declaration)
	" Return a function template docstring.
	"
	" Heuristics are used to determine whether the function returns anything.
	" A typical function docstring might look like:
	"
	"   '''
	"   Return the square of a number.
	"
	"   :param number: The number to be squared.
	"
	"   :type number: int
	"
	"   :return: The square of **number**.
	"   :rtype: int
	"   '''
	"
	" Args:
	"   declaration : A string containing a Python function declaration.

	let params = ""
	let types = ""
	for arg_name in split(matchstr(a:declaration, "(.*)")[1:-2], ",")
		if arg_name != "self"
			if arg_name[0] == " "
				let arg_name = arg_name[1:]
			endif
			let arg_name = split(arg_name, "=")[0]

			let params .= ":param " . arg_name . ": \n"
			let types .= ":type " . arg_name . ": \n"
		endif
	endfor

	if len(l:params) > 0
		let params = "\n" . params
		let types = "\n" . types
	endif

	let return = len(split(GetPythonBlock(), "return \\(.\\+\\)\\@=")) > 1?
		\"\n:return: \n:rtype: \n":""

	return IndentDocstring("\"\"\"\n" . params . types . return . "\"\"\"")
endfunc

func! ClassComment()
	" Return a class template docstring.
	"
	" Heuristics are used to identify any instance variables.
	" A typical class docstring might look like:
	"
	"   '''
	"   A person class.
	"
	"   :ivar name: (str) The name of the person.
	"   :ivar age: (int) The age of the person.
	"   '''

	let instance_vars = []

	for snippet in split(GetPythonBlock(), "self\\.")[1:]
		let instance_var = matchstr(snippet, "^[a-zA-Z_0-9]\\+.")
		if instance_var[-1:] != "(" && instance_var !~ "__.*__"
			call add(instance_vars, instance_var[:-2])
		endif
	endfor

	let instance_vars = filter(copy(instance_vars),
		\"index(instance_vars, v:val, v:key+1)==-1")

	let instance_vars_comment = ""
	for instance_var in instance_vars
		let instance_vars_comment .= ":ivar " .  instance_var . ": () \n"
	endfor

	if len(instance_vars) > 0
		let instance_vars_comment = "\n" . instance_vars_comment
	endif

	return IndentDocstring("\"\"\"\n" . instance_vars_comment . "\"\"\"")
endfunc

func! ModuleComment()
	" Return a module template docstring.
	"
	" A typical module docstring might look like:
	"
	"   '''
	"   :synopsis:
	"   '''

	return "\"\"\"\n:synopsis: \n\"\"\"\n"
endfunc

func! GetCurrentIndent()
	" Store the current line's indentation level as a global string.

	let g:_tab = &et?repeat(" ", &tabstop):"\t"
	let g:_curr_indent = matchstr(getline("."), "^[\\t ]*\\([^ \\t]\\)\\@=")
endfunc

func! IndentDocstring(docstring)
	" Indent all lines of a docstring, as per the current line's indentation
	" level.
	"
	" Args:
	"   docstring : (str) A docstring generated by functions like
	"       ModuleComment(), ClassComment(), etc..

	let docstring_lines = []
	for line in split(a:docstring, "\n")
		if len(line) > 0
			call add(docstring_lines, g:_curr_indent . g:_tab . line)
		else
			call add(docstring_lines, line)
		endif
	endfor
	return join(docstring_lines, "\n") . "\n\n"
endfunc

func! GetPythonBlock()
	" Return the block of code following the current line.
	"
	" Return the block of Python code consisting of either blank lines or lines
	" with a greater indentation level than the current line. Examples include
	" the body of a class, for-loop, or if-statement.
	let target_line = "\\n\\(^" . g:_curr_indent . "[^" . g:_tab . "]\\)\\@="
	let col = col(".")
	let line = line(".")

	if search(target_line, "nW") == 0
		exec "normal! 0\"ayG$\<cr>"
	else
		exec "normal! 0\"ay/" . target_line . "\<cr>"
	endif

	call cursor(line, col)
	return @a
endfunc

so ~/.vimrc_after
