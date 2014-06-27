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
syn match _pythonMagic "__[a-zA-Z]\+__"
syn match _pythonKeyword "self"
syn region Comment start=/"""/ end=/"""/

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

inorem <buffer> __ ____<left><left>

so ~/.vimrc_after
