Ftpackage curly_bracket

Synclude arithmetic_operator ctermfg=3 contains=ALL
Synclude constant ctermfg=5
Synclude surrounding_element ctermfg=3
Synclude logic_operator ctermfg=5
Synclude shell_script_path ctermfg=3

syn match _zshfunction "^.*\((){$\)\@="

hi _zshfunction ctermfg=4
hi _zshpath cterm=italic ctermfg=3

so ~/.vimrc_after
