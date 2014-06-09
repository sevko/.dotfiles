setlocal colorcolumn=121

syn region djangoTagBlock start="\(^[\t ]*\)=" end="$"
	\ contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError
	\ display containedin=ALLBUT,@djangoBlocks

inorem <buffer> % %<Space>%<left><Left>
inorem <buffer> { {}<Left>
