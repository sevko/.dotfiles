Ftpackage curly_bracket

Synclude arithmetic_operator ctermfg=3
Synclude constant ctermfg=5
Synclude surrounding_element ctermfg=3

syn match _zshfunction "^.*\((){$\)\@="
syn match _zshpath "\([a-zA-Z0-9_-]\)\@<!\(\/\|\~\|$[^ \t]\+\/\)[^ \t]*"

hi _zshfunction ctermfg=4
hi _zshpath cterm=italic ctermfg=3

so ~/.vimrc_after
