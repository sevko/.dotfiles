set ts=4 sw=4 noet
UltiSnipsAddFiletypes java

Ftpackage curly_bracket

Synclude constant cterm=bold ctermfg=70
syn match _arithmetic_operator '[+\-%=*]\|[*\/]\@<!\/[*\/]\@!'
syn match _delimiter "[,;.]"
Synclude ternary ctermfg=1
Synclude logic_operator ctermfg=9
Synclude equality_operator ctermfg=4
Synclude bitwise_operator ctermfg=1
Synclude surrounding_element ctermfg=9

hi _arithmetic_operator ctermfg=3
hi _delimiter ctermfg=242

syn clear javaCommentTitle

so ~/.vimrc_after
