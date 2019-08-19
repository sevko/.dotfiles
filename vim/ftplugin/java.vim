Ftpackage curly_bracket

inoremap < <><Left>

syn clear javaCommentTitle
syn match _arithmetic_operator '[+\-%=*]\|[*\/]\@<!\/[*\/]\@!'
syn match _delimiter "[,;]"
Synclude bitwise_operator ctermfg=1
Synclude constant cterm=bold ctermfg=14
Synclude equality_operator ctermfg=4
Synclude surrounding_element ctermfg=2
Synclude delimiter containedin=ALL ctermfg=11

syn match _javaClassName "\v(\W)@<=\u\w+" contains=_java_constant
hi _javaClassName ctermfg=14 cterm=italic
hi _arithmetic_operator ctermfg=9

so ~/.vimrc_after
