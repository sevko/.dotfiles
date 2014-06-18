Ftpackage curly_bracket

Synclude constant cterm=bold ctermfg=70

syn match _javascriptFunction "\(function \)\@<=[^ \t]\+\((.*){$\)\@="
syn match _javascriptLibraryPrefix "\(\W\?\)\@<=[$]"

hi _javascriptFunction ctermfg=4
hi _javascriptLibraryPrefix ctermfg=1
hi javascriptFunction ctermfg=3
hi javaScriptSpecialCharacter ctermfg=1
hi javaScriptBraces ctermfg=1
hi javaScriptFuncExp cterm=none ctermfg=9

so ~/.vimrc_after
