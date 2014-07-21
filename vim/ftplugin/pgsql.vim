Synclude arithmetic_operator ctermfg=3 contains=pgsqlComment
syn match _pgsql_function "\v[a-zA-Z0-9_]*\(@="
Synclude surrounding_element ctermfg=4
Synclude delimiter ctermfg=242

hi _pgsql_function ctermfg=9

nnorem <buffer> <leader>;
	\ :exe "norm! $" . ("{," =~ getline(".")[-1:]?"r":"a") . ";"<cr>
inorem <buffer> \| <space>\|\|<space>
inorem <buffer> \|\| \|

so ~/.vimrc_after
