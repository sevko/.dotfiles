Ftpackage curly_bracket

Synclude constant cterm=bold ctermfg=70
Synclude ternary ctermfg=5
Synclude delimiter ctermfg=11

syn keyword Identifier console
syn keyword Constant NaN Infinity
syn match Statement "['"]use strict['"];"
syn match _javascript_arithmetic_operator '[+\-%=*]\|[*\/]\@<!\/[*\/]\@!'
syn match _javascript_function "\(function \)\@<=[^ \t]\+\((.*){$\)\@="
syn match _javascript_library_prefix "\(\W\?\)\@<=[$]"

hi _javascript_arithmetic_operator ctermfg=2
hi _javascript_function ctermfg=4
hi _javascript_library_prefix ctermfg=1
hi javascriptFunction ctermfg=3
hi javaScriptSpecialCharacter ctermfg=1
hi javaScriptBraces ctermfg=1
hi javaScriptFuncExp cterm=none ctermfg=9

so ~/.vimrc_after
