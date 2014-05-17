setlocal colorcolumn=121

syn region djangoTagBlock start="\(^[\t ]*\)=" end="$"
	\ contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError
	\ display containedin=ALLBUT,@djangoBlocks

inoreab <buffer> % %<Space>%<left><Left>
inoreab { {}<Left>
