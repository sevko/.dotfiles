let &l:include = '\v^\zs(from|import).*\ze$'
setl noet softtabstop=0 ts=4 sw=4
setl iskeyword+=\
setl path+=/usr/lib/python2.7
setl includeexpr=ResolveIncludePath(v:fname)
let g:pyindent_open_paren="shiftwidth()"

Synclude arithmetic_operator ctermfg=3
Synclude bitwise_operator ctermfg=1
Synclude constant cterm=bold ctermfg=14
Synclude equality_operator ctermfg=4
Synclude surrounding_element ctermfg=2
Synclude delimiter ctermfg=242

syn match pythonStrFormatting
	\ "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]"
	\ contained containedin=pythonString,pythonRawString
syn match pythonStrFormatting
	\ "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]"
	\ contained containedin=pythonString,pythonRawString
syn match pythonStrFormatting "{\d\+}" containedin=pythonString,pythonRawString
syn match _pythonImportedModule "\v((import|from) )@<=\S+"
syn match _pythonMagic "__[a-zA-Z]\+__"
syn keyword _pythonBuiltin self cls
syn region Comment start=/"""\|'''/ end=/"""\|'''/

hi _delimiter ctermfg=242
hi _pythonBuiltin ctermfg=3
hi _pythonImportedModule ctermfg=6
hi _pythonDocstringBrief cterm=bold ctermfg=10
hi _pythonMagic ctermfg=9
hi _pythonSphinxField cterm=bold ctermfg=10
hi _pythonSphinxStandardDomain cterm=bold ctermfg=10
hi _pythonSphinxReference cterm=bold ctermfg=10
hi _pythonSphinxItalics cterm=italic ctermfg=10
hi _pythonSphinxBold cterm=bold ctermfg=10
hi pythonFunction ctermfg=4
hi pythonStatement cterm=reverse,bold ctermfg=0 ctermbg=2
hi pythonStrFormatting ctermfg=5

inorem <buffer> __ ____<left><left>

func! ResolveIncludePath(path)
	if a:path[:3] == "from"
		let components = split(a:path)
		if len(components) != 4
			return ""
		endif
		let base_path = substitute(l:components[1], '\.', "/", "g")

		let file_path = l:base_path . ".py"
		if filereadable(l:file_path)
			return l:file_path
		else
			let import_path = printf("%s/%s", l:base_path, components[3])
		endif
	else
		let module_path = split(a:path)[1]
		let import_path = substitute(l:module_path, '\.', "/", "g")
	endif

	if isdirectory(l:import_path)
		let l:import_path .= "/__init__"
	endif
	let l:import_path .= ".py"

	echom a:path . " : " . l:import_path
	return l:import_path
endfunc

so ~/.vimrc_after
