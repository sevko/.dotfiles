" Plugin for common syntax match imports.
"
" Contains functions and commands that allow for easy inclusion (importing) of
" syntax matches that are common across programming languages, like constants
" or bitwise operators, to prevent redefinition (DRY).

let g:common_syntax_groups = {}

func! s:PopulateCommonSyntaxGroups()
	" Read in syntax matches defined in 'groups.syn', and populate
	" `g:common_syntax_groups`.

	for line in readfile(glob("~/.dotfiles/vim/scripts/Synclude/groups.syn"))
		let split_line = split(l:line)
		let g:common_syntax_groups[l:split_line[0]] = join(split_line[1:], " ")
	endfor
endfunc

" Import a syntax match.
"
" Args:
"   1 : The name of the match.
com! -nargs=1 Synclude exe printf("syn match _%s %s", "<args>",
	\g:common_syntax_groups["<args>"])

call s:PopulateCommonSyntaxGroups()
